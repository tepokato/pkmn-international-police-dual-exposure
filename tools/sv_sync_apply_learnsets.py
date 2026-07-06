#!/usr/bin/env python3
"""Replace regional-dex level-up learnsets with Scarlet/Violet (mapped ROM moves).

Uses PokeAPI data via tools/sv_sync.py. Preserves evo_data lines and conditional
learnsets (if DEF(FAITHFUL) / if !DEF(FAITHFUL)) when those moves are not in SV.

Usage:
  python3 tools/sv_sync_apply_learnsets.py          # patch evos_attacks.asm
  python3 tools/sv_sync_apply_learnsets.py --dry-run
"""

from __future__ import annotations

import argparse
import re
import sys
import urllib.error
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from tools.sv_sync import (  # noqa: E402
    EVOS_ATTACKS,
    SKIP_SPECIES_FILES,
    api_to_rom,
    evos_label_for_file,
    fetch_sv_level_moves,
    filename_to_api_name,
    list_base_stat_files,
    load_regional_dex,
    parse_move_constants,
)

EVO_LINE = re.compile(r"^\tevo_data\b")
LEARNSET_LINE = re.compile(r"^\tlearnset\s+(\d+)\s*,\s*(\w+)")
BLOCK_START = re.compile(r"^\tevos_attacks\s+(\w+)\s*$")
BLOCK_END = re.compile(r"^\tend_evos_attacks\b")
IF_LINE = re.compile(r"^if\s+(!?)DEF\((\w+)\)")
ENDC_LINE = re.compile(r"^endc\s*$")


def file_to_label(filename: str) -> str:
    return evos_label_for_file(filename)


def build_regional_labels(regional) -> dict[str, str]:
    """evos_attacks label -> base_stats filename."""
    out: dict[str, str] = {}
    for fn in list_base_stat_files(regional):
        if fn in SKIP_SPECIES_FILES:
            continue
        out[file_to_label(fn)] = fn
    return out


def sv_rom_learnset(api: str, rom_moves: set[str]) -> list[tuple[int, str]]:
    sv = fetch_sv_level_moves(api)
    best: dict[str, int] = {}
    for lvl, api_mv in sv:
        rom = api_to_rom(api_mv, rom_moves)
        if rom is not None:
            if rom not in best or lvl < best[rom]:
                best[rom] = lvl
    return sorted(((lvl, mv) for mv, lvl in best.items()), key=lambda x: (x[0], x[1]))


def extract_evo_lines(body: list[str]) -> list[str]:
    return [ln for ln in body if EVO_LINE.match(ln.rstrip("\n"))]


def extract_ifdef_blocks(body: list[str]) -> list[list[str]]:
    """Return raw if/endc blocks that contain learnset lines."""
    blocks: list[list[str]] = []
    i = 0
    while i < len(body):
        stripped = body[i].rstrip("\n")
        m = IF_LINE.match(stripped)
        if not m:
            i += 1
            continue
        block = [body[i]]
        i += 1
        has_learnset = False
        while i < len(body):
            block.append(body[i])
            if LEARNSET_LINE.match(body[i].rstrip("\n")):
                has_learnset = True
            if ENDC_LINE.match(body[i].rstrip("\n")):
                i += 1
                break
            i += 1
        if has_learnset:
            blocks.append(block)
    return blocks


def learnset_keys(body: list[str]) -> set[tuple[int, str]]:
    keys: set[tuple[int, str]] = set()
    for ln in body:
        m = LEARNSET_LINE.match(ln.rstrip("\n"))
        if m:
            keys.add((int(m.group(1)), m.group(2)))
    return keys


def format_learnset_lines(entries: list[tuple[int, str]]) -> list[str]:
    return [f"\tlearnset {lvl}, {mv}\n" for lvl, mv in entries]


def learnset_move_names(body: list[str]) -> set[str]:
    names: set[str] = set()
    for ln in body:
        m = LEARNSET_LINE.match(ln.rstrip("\n"))
        if m:
            names.add(m.group(2))
    return names


def rebuild_block(
    evo_lines: list[str],
    learn_entries: list[tuple[int, str]],
    ifdef_blocks: list[list[str]],
    applied_moves: set[str],
) -> list[str]:
    out: list[str] = []
    out.extend(evo_lines)
    out.extend(format_learnset_lines(learn_entries))
    for block in ifdef_blocks:
        block_moves = learnset_move_names(block)
        if block_moves & applied_moves:
            continue
        out.extend(block)
    return out


def apply_learnsets(dry_run: bool = False) -> int:
    regional = load_regional_dex()
    if regional is None:
        print("No regional_dex.txt found.", file=sys.stderr)
        return 1

    label_to_file = build_regional_labels(regional)
    rom_moves = parse_move_constants()
    text = EVOS_ATTACKS.read_text()
    lines = text.splitlines(keepends=True)

    patched = 0
    skipped = 0
    out: list[str] = []
    i = 0
    while i < len(lines):
        m = BLOCK_START.match(lines[i].rstrip("\n"))
        if not m:
            out.append(lines[i])
            i += 1
            continue

        label = m.group(1)
        out.append(lines[i])
        i += 1
        body: list[str] = []
        while i < len(lines):
            if BLOCK_START.match(lines[i].rstrip("\n")) or BLOCK_END.match(
                lines[i].rstrip("\n")
            ):
                break
            body.append(lines[i])
            i += 1

        fn = label_to_file.get(label)
        if not fn:
            out.extend(body)
            continue

        api = filename_to_api_name(fn)
        if not api:
            out.extend(body)
            skipped += 1
            continue

        try:
            target = sv_rom_learnset(api, rom_moves)
        except urllib.error.HTTPError:
            out.extend(body)
            skipped += 1
            continue

        if not target:
            out.extend(body)
            skipped += 1
            continue

        evo_lines = extract_evo_lines(body)
        ifdef_blocks = extract_ifdef_blocks(body)
        applied_moves = {mv for _, mv in target}
        new_body = rebuild_block(evo_lines, target, ifdef_blocks, applied_moves)
        if new_body != body:
            patched += 1
            if not dry_run:
                print(f"  {label} ({fn}): {len(target)} SV moves")
        out.extend(new_body)

    if not dry_run:
        EVOS_ATTACKS.write_text("".join(out))

    print(f"Patched {patched} species, skipped {skipped}, unchanged {len(label_to_file) - patched - skipped}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="report changes without writing evos_attacks.asm",
    )
    args = parser.parse_args()
    regional = load_regional_dex()
    if regional:
        print(f"Regional dex: {len(regional.in_rom)} species")
    return apply_learnsets(dry_run=args.dry_run)


if __name__ == "__main__":
    sys.exit(main())
