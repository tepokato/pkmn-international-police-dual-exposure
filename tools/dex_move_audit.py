#!/usr/bin/env python3
"""Audit which moves are unused by the regional dex species.

Compares move usage from level-up learnsets, TMs/tutors, egg moves, and
evolution moves for regional-dex species vs the rest of the ROM dex.

Usage:
  python3 tools/dex_move_audit.py
  python3 tools/dex_move_audit.py --json

Writes tools/dex_move_audit/report.md and gaps.json
"""

from __future__ import annotations

import argparse
import json
import re
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGIONAL_DEX = ROOT / "data/pokemon/regional_dex.txt"
BASE_STATS_INDEX = ROOT / "data/pokemon/base_stats.asm"
BASE_STATS_DIR = ROOT / "data/pokemon/base_stats"
MOVE_CONSTANTS = ROOT / "constants/move_constants.asm"
EVOS_ATTACKS = ROOT / "data/pokemon/evos_attacks.asm"
EGG_MOVES = ROOT / "data/pokemon/egg_moves.asm"
EGG_POINTERS = ROOT / "data/pokemon/egg_move_pointers.asm"
EVOLUTION_MOVES = ROOT / "data/pokemon/evolution_moves.asm"
TMHM_CONSTANTS = ROOT / "constants/tmhm_constants.asm"
OUT_DIR = ROOT / "tools/dex_move_audit"

# Moves that must stay even if no dex species learns them
ALWAYS_KEEP = {
    "NO_MOVE",
    "STRUGGLE",
    "MIRROR_MOVE",
    "SKETCH",
    "METRONOME",
    "ASSIST",
    "COPYCAT",
    "NATURE_POWER",
    "SLEEP_TALK",  # tutor staple
}

# Legacy aliases / HM slots that share data with other moves
LEGACY_ALIASES = {
    "SURF",
    "CRABHAMMER",
    "BONEMERANG",
    "OCTAZOOKA",
    "ZAP_CANNON",
    "CUT",
    "STRENGTH",
    "WHIRLPOOL",
    "HM_CUT",
    "HM_FLY",
    "HM_SURF",
    "HM_STRENGTH",
    "HM_WHIRLPOOL",
    "HM_WATERFALL",
}


def load_regional_dex() -> set[str]:
    files: set[str] = set()
    for line in REGIONAL_DEX.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        entry = line.split(";", 1)[0].strip()
        if entry.upper().startswith("PLANNED "):
            entry = entry[8:].strip()
        if entry.endswith(".asm"):
            files.add(entry)
    return files


def load_rom_species() -> list[str]:
    species: list[str] = []
    for line in BASE_STATS_INDEX.read_text().splitlines():
        if "assert_table_length NUM_SPECIES" in line:
            break
        m = re.search(r'INCLUDE "data/pokemon/base_stats/([^"]+)"', line)
        if m:
            species.append(m.group(1))
    return species


def label_for_file(filename: str) -> str:
    base = filename.removesuffix(".asm")
    return "".join(p.capitalize() for p in base.split("_"))


def parse_moves() -> list[str]:
    moves: list[str] = []
    for line in MOVE_CONSTANTS.read_text().splitlines():
        if "DEF NUM_ATTACKS" in line:
            break
        m = re.match(r"\s*const\s+(\w+)\s*;", line)
        if m and m.group(1) != "NO_MOVE":
            moves.append(m.group(1))
    return moves


def parse_tmhm_map() -> list[str]:
    """Move constants that are TMs, HMs, or tutors."""
    text = TMHM_CONSTANTS.read_text()
    return [
        m.group(1)
        for m in re.finditer(r"^\s*add_(?:tm|tutor|hm)\s+(\w+)", text, re.M)
    ]


def parse_learnsets() -> dict[str, set[str]]:
    sets: dict[str, set[str]] = {}
    current: str | None = None
    for line in EVOS_ATTACKS.read_text().splitlines():
        m = re.match(r"\s*evos_attacks\s+(\w+)", line)
        if m:
            current = m.group(1)
            sets.setdefault(current, set())
            continue
        m = re.match(r"\s*learnset\s+\d+\s*,\s*(\w+)", line)
        if m and current:
            sets[current].add(m.group(1))
    return sets


def parse_egg_pointers() -> list[str]:
    labels: list[str] = []
    for line in EGG_POINTERS.read_text().splitlines():
        if "assert_table_length NUM_SPECIES" in line:
            break
        m = re.match(r"\tdw\s+(\w+)EggSpeciesMoves", line)
        if m:
            labels.append(m.group(1))
    return labels


def parse_egg_moves() -> dict[str, set[str]]:
    text = EGG_MOVES.read_text()
    sets: dict[str, set[str]] = {}
    current: str | None = None
    for line in text.splitlines():
        m = re.match(r"(\w+)EggSpeciesMoves:", line)
        if m:
            current = m.group(1)
            sets[current] = set()
            continue
        m = re.match(r"\tdb\s+(\w+)", line)
        if m and current and m.group(1) != "-1":
            sets[current].add(m.group(1))
    return sets


def parse_evolution_moves() -> list[str | None]:
    moves: list[str | None] = []
    for line in EVOLUTION_MOVES.read_text().splitlines():
        if "assert_table_length NUM_SPECIES" in line:
            break
        m = re.match(r"\tdb\s+(\w+)", line)
        if m:
            mv = m.group(1)
            moves.append(None if mv == "NO_MOVE" else mv)
    return moves


def parse_tmhm_from_base_stats(filename: str) -> set[str]:
    path = BASE_STATS_DIR / filename
    if not path.exists():
        return set()
    text = path.read_text()
    m = re.search(r"\ttmhm\s+(.+)", text)
    if not m:
        return set()
    part = m.group(1).split(";")[0]
    return {tok.strip() for tok in part.split(",") if tok.strip()}


def scan_hardcoded_move_refs() -> dict[str, set[str]]:
    """Moves referenced outside learnset data (scripts, AI, items, etc.)."""
    refs: dict[str, set[str]] = defaultdict(set)
    skip_dirs = {".git", "tools/dex_move_audit", "tools/sv_sync/cache"}
    patterns = [
        re.compile(r"\b([A-Z][A-Z0-9_]+)\b"),
    ]
    data_dirs = [
        ROOT / "maps",
        ROOT / "engine",
        ROOT / "home",
        ROOT / "data/items",
        ROOT / "data/moves",
        ROOT / "data/battle_tower",
        ROOT / "data/trainers",
    ]
    move_names = set(parse_moves()) | ALWAYS_KEEP | LEGACY_ALIASES
  # load once
    for base in data_dirs:
        if not base.exists():
            continue
        for path in base.rglob("*.asm"):
            if any(p in path.parts for p in skip_dirs):
                continue
            rel = str(path.relative_to(ROOT))
            if rel in (
                "data/pokemon/evos_attacks.asm",
                "data/pokemon/egg_moves.asm",
                "data/pokemon/evolution_moves.asm",
                "data/pokemon/base_stats.asm",
            ):
                continue
            if "base_stats/" in rel:
                continue
            try:
                text = path.read_text(errors="ignore")
            except OSError:
                continue
            for mv in move_names:
                if re.search(rf"\b{re.escape(mv)}\b", text):
                    refs[mv].add(rel)
    return refs


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--json", action="store_true", help="print JSON summary to stdout")
    args = parser.parse_args()

    regional = load_regional_dex()
    rom_species = load_rom_species()
    all_moves = set(parse_moves())
    learnsets = parse_learnsets()
    egg_ptrs = parse_egg_pointers()
    egg_sets = parse_egg_moves()
    evo_moves = parse_evolution_moves()

    dex_moves: dict[str, set[str]] = defaultdict(set)
    non_dex_moves: dict[str, set[str]] = defaultdict(set)
    dex_species_count = 0
    non_dex_species_count = 0

    for i, fn in enumerate(rom_species):
        label = label_for_file(fn)
        in_dex = fn in regional
        if in_dex:
            dex_species_count += 1
        else:
            non_dex_species_count += 1
        bucket = dex_moves if in_dex else non_dex_moves

        for mv in learnsets.get(label, set()):
            bucket[mv].add(f"level:{label}")

        for mv in parse_tmhm_from_base_stats(fn):
            bucket[mv].add(f"tm:{label}")

        if i < len(egg_ptrs):
            egg_label = egg_ptrs[i]
            for mv in egg_sets.get(egg_label, set()):
                bucket[mv].add(f"egg:{label}")

        if i < len(evo_moves) and evo_moves[i]:
            bucket[evo_moves[i]].add(f"evo:{label}")

    dex_move_set = set(dex_moves.keys())
    non_dex_only_moves = {
        mv
        for mv, sources in non_dex_moves.items()
        if mv not in dex_move_set and mv not in ALWAYS_KEEP and mv not in LEGACY_ALIASES
    }

    all_species_moves = dex_move_set | set(non_dex_moves.keys())
    orphan_moves = {
        mv
        for mv in all_moves
        if mv not in all_species_moves
        and mv not in ALWAYS_KEEP
        and mv not in LEGACY_ALIASES
    }

    dex_unused_by_learnset = {
        mv
        for mv in all_moves
        if mv not in dex_move_set
        and mv not in ALWAYS_KEEP
        and mv not in LEGACY_ALIASES
    }

    hardcoded = scan_hardcoded_move_refs()
    ignore_refs = {
        "data/moves/moves.asm",
        "data/moves/names.asm",
        "data/moves/descriptions.asm",
        "data/moves/animation_pointers.asm",
        "data/moves/tmhm_moves.asm",
    }
    removable = []
    caution = []
    for mv in sorted(dex_unused_by_learnset):
        refs = hardcoded.get(mv, set()) - ignore_refs
        if refs:
            caution.append(mv)
        else:
            removable.append(mv)

    tm_unused: list[str] = []
    for mv in parse_tmhm_map():
        if mv in LEGACY_ALIASES or mv in ALWAYS_KEEP:
            continue
        users = [fn for fn in regional if mv in parse_tmhm_from_base_stats(fn)]
        if not users:
            tm_unused.append(mv)

    non_dex_species_files = [fn for fn in rom_species if fn not in regional]

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    report = {
        "regional_dex_species": len(regional),
        "rom_species_in_dex_table": dex_species_count,
        "rom_species_not_in_regional_dex": non_dex_species_count,
        "non_dex_species_files_sample": non_dex_species_files[:40],
        "total_attack_moves_in_rom": len(all_moves),
        "moves_used_by_regional_dex": len(dex_move_set),
        "moves_not_learned_by_regional_dex": len(dex_unused_by_learnset),
        "moves_only_non_dex_species": len(non_dex_only_moves),
        "non_dex_exclusive_moves": sorted(non_dex_only_moves),
        "orphan_moves_no_species": sorted(orphan_moves),
        "likely_removable": removable,
        "keep_due_to_hardcoded_refs": {
            mv: sorted(hardcoded.get(mv, set()) - ignore_refs)[:8] for mv in caution
        },
        "tm_tutor_unused_by_regional_dex": tm_unused,
        "dex_unused_moves": sorted(dex_unused_by_learnset),
    }
    (OUT_DIR / "gaps.json").write_text(json.dumps(report, indent=2) + "\n")

    lines = [
        "# Regional dex move audit",
        "",
        f"Regional dex: **{len(regional)}** species | ROM dex table: **{dex_species_count}** in dex / **{non_dex_species_count}** not in dex",
        "",
        "## Summary",
        "",
        f"| Metric | Count |",
        f"|--------|------:|",
        f"| Total attack moves in ROM | {len(all_moves)} |",
        f"| Moves used by regional dex (level/TM/egg/evo) | {len(dex_move_set)} |",
        f"| Moves **not** learned by any regional dex species | **{len(dex_unused_by_learnset)}** |",
        f"| Of those, only non-dex ROM species learn | {len(non_dex_only_moves)} |",
        f"| Moves not on any species learnset path | {len(orphan_moves)} |",
        f"| Likely safe to remove / repurpose | **{len(removable)}** |",
        f"| Keep (hardcoded in battle/scripts) | {len(caution)} |",
        f"| TM/tutor moves no dex species learns | {len(tm_unused)} |",
        "",
        "## Moves not learned by any regional dex species",
        "",
        "Primary trim list for your 246-species dex.",
        "",
    ]
    if dex_unused_by_learnset:
        for mv in sorted(dex_unused_by_learnset):
            tag = " *(non-dex exclusive)*" if mv in non_dex_only_moves else ""
            lines.append(f"- `{mv}`{tag}")
    else:
        lines.append("_None._")

    lines += [
        "",
        "## Likely removable (no dex learnset + no script refs)",
        "",
    ]
    if removable:
        for mv in removable:
            src = sorted(non_dex_moves.get(mv, set()))[:3]
            extra = f" — was: {', '.join(src)}" if src else " — no species source"
            lines.append(f"- `{mv}`{extra}")
    else:
        lines.append("_None._")

    lines += [
        "",
        "## Keep despite no dex learnsets (hardcoded references)",
        "",
    ]
    if caution:
        for mv in caution[:40]:
            refs = ", ".join(f"`{r}`" for r in report["keep_due_to_hardcoded_refs"][mv][:4])
            lines.append(f"- `{mv}` — {refs}")
        if len(caution) > 40:
            lines.append(f"- … +{len(caution) - 40} more in `gaps.json`")
    else:
        lines.append("_None._")

    lines += [
        "",
        "## TM / tutor moves no regional species learns",
        "",
        "These could be removed from shops/tutors if you trim TM inventory to dex-only.",
        "",
    ]
    if tm_unused:
        lines.append(", ".join(f"`{m}`" for m in tm_unused))
    else:
        lines.append("_None._")

    lines += [
        "",
        "## Notes",
        "",
        "- Trainers usually inherit moves from level-up learnsets at battle time; this audit is species-centric.",
        "- Variant forms (Alolan, etc.) count as non-dex unless listed in `regional_dex.txt`.",
        "- `ALWAYS_KEEP` includes Struggle, Transform, tutor staples, etc.",
        "- Full detail: `tools/dex_move_audit/gaps.json`",
        "",
    ]
    (OUT_DIR / "report.md").write_text("\n".join(lines) + "\n")

    if args.json:
        print(json.dumps({k: v for k, v in report.items() if k != "non_dex_only_detail"}, indent=2))
    else:
        print(f"Wrote {OUT_DIR / 'report.md'}")
        print(f"Regional dex uses {len(dex_move_set)} / {len(all_moves)} attack moves")
        print(f"Not learned by regional dex: {len(dex_unused_by_learnset)}")
        print(f"Likely removable: {len(removable)} | Keep (hardcoded): {len(caution)}")
        print(f"Unused TMs/tutors for dex: {len(tm_unused)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
