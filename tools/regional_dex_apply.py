#!/usr/bin/env python3
"""Apply regional dex scope: move distribution, legend move cleanup, encounter fixes."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
import sys

sys.path.insert(0, str(ROOT))

EVOS_ATTACKS = ROOT / "data/pokemon/evos_attacks.asm"
BATTLE_TOWER = ROOT / "data/battle_tower/parties.asm"
ODD_EGGS = ROOT / "data/events/odd_eggs.asm"
BASE_STATS_DIR = ROOT / "data/pokemon/base_stats"

from tools.regional_dex_scope import load_regional_files  # noqa: E402

# --- Phase 1: learnset additions (label -> [(level, move), ...]) ---
LEARNSET_ADD: dict[str, list[tuple[int, str]]] = {
    "GeodudePlain": [(16, "STEALTH_ROCK")],
    "GravelerPlain": [(16, "STEALTH_ROCK")],
    "GolemPlain": [(16, "STEALTH_ROCK")],
    "Onix": [(20, "STEALTH_ROCK")],
    "Steelix": [(20, "STEALTH_ROCK")],
    "Skarmory": [(25, "STEALTH_ROCK")],
    "Bronzor": [(28, "STEALTH_ROCK")],
    "Bronzong": [(28, "STEALTH_ROCK")],
    "Larvitar": [(18, "STEALTH_ROCK")],
    "Aron": [(22, "STEALTH_ROCK")],
    "Natu": [(24, "DEFOG")],
    "Xatu": [(24, "DEFOG")],
    "Hoothoot": [(22, "DEFOG")],
    "Noctowl": [(22, "DEFOG")],
    "Murkrow": [(26, "DEFOG")],
    "Honchkrow": [(26, "DEFOG")],
    "Girafarig": [(30, "DEFOG")],
    "Farigiraf": [(30, "DEFOG")],
    "Crobat": [(28, "DEFOG")],
    "Clefairy": [(32, "HEAL_BLOCK")],
    "Clefable": [(32, "HEAL_BLOCK")],
    "Ralts": [(28, "HEAL_BLOCK")],
    "Kirlia": [(32, "HEAL_BLOCK")],
    "Gardevoir": [(36, "HEAL_BLOCK")],
    "Chansey": [(40, "HEAL_BLOCK")],
    "Blissey": [(40, "HEAL_BLOCK")],
    "Gallade": [(1, "SACRED_SWORD")],
    "Lucario": [(42, "SACRED_SWORD")],
    "Bisharp": [(48, "SACRED_SWORD")],
    "Kingambit": [(52, "SACRED_SWORD")],
}

# TM tutor line additions (base_stats filename -> moves)
TMHM_ADD: dict[str, list[str]] = {
    "madame.asm": ["SACRED_SWORD"],
    "farfetch_d_plain.asm": ["SACRED_SWORD"],
    "gallade.asm": ["SACRED_SWORD"],
    "lucario.asm": ["SACRED_SWORD"],
    "pawniard.asm": ["SACRED_SWORD"],
    "bisharp.asm": ["SACRED_SWORD"],
    "kingambit.asm": ["SACRED_SWORD"],
    "geodude_plain.asm": ["STEALTH_ROCK"],
    "golem_plain.asm": ["STEALTH_ROCK"],
    "onix.asm": ["STEALTH_ROCK"],
    "steelix.asm": ["STEALTH_ROCK"],
    "skarmory.asm": ["STEALTH_ROCK"],
    "bronzor.asm": ["STEALTH_ROCK"],
    "bronzong.asm": ["STEALTH_ROCK"],
    "natu.asm": ["DEFOG"],
    "xatu.asm": ["DEFOG"],
    "murkrow.asm": ["DEFOG"],
    "honchkrow.asm": ["DEFOG"],
    "clefable.asm": ["HEAL_BLOCK"],
    "gardevoir.asm": ["HEAL_BLOCK"],
    "blissey.asm": ["HEAL_BLOCK"],
}

# --- Phase 2: replace legend-exclusive moves in learnsets ---
LEARNSET_REPLACE = {
    "AEROBLAST": "HURRICANE",
    "SACRED_FIRE": "FLARE_BLITZ",
}

# --- Phase 3: non-regional species -> regional substitute (target must be in regional dex) ---
REPLACEMENTS: dict[str, str] = {
    "ABRA": "RALTS",
    "KADABRA": "KIRLIA",
    "ALAKAZAM": "GARDEVOIR",
    "AERODACTYL": "KABUTOPS",
    "ANNIHILAPE": "MACHAMP",
    "ARTICUNO": "XATU",
    "BAYLEEF": "SKIPLOOM",
    "BEEDRILL": "LEDIAN",
    "BLASTOISE": "KINGDRA",
    "BULBASAUR": "ODDISH",
    "IVYSAUR": "GLOOM",
    "VENUSAUR": "VILEPLUME",
    "BUTTERFREE": "LEDIAN",
    "CATERPIE": "LEDYBA",
    "METAPOD": "SPINARAK",
    "CHARIZARD": "HOUNDOOM",
    "CHARMANDER": "SLUGMA",
    "CHARMELEON": "MAGCARGO",
    "CHIKORITA": "HOPPIP",
    "CYNDAQUIL": "GROWLITHE",
    "CROCONAW": "QUAGSIRE",
    "TOTODILE": "WOOPER",
    "FERALIGATR": "KINGDRA",
    "MEGANIUM": "JUMPLUFF",
    "QUILAVA": "FLAAFFY",
    "TYPHLOSION": "ARCANINE",
    "CLODSIRE": "QUAGSIRE",
    "CORSOLA": "SHELLDER",
    "CUBONE": "GEODUDE",
    "CURSOLA": "GASTLY",
    "DELIBIRD": "HYPNO",
    "ENTEI": "ARCANINE",
    "FEAROW": "NOCTOWL",
    "FORRETRESS": "PINECO",
    "GOLDUCK": "SLOWBRO",
    "JIGGLYPUFF": "CLEFFA",
    "JYNX": "HYPNO",
    "KAKUNA": "SPINARAK",
    "KLEAVOR": "HERACROSS",
    "MAMOSWINE": "SEEL",
    "MANKEY": "MACHOP",
    "MANTINE": "TENTACRUEL",
    "MAROWAK": "GEODUDE",
    "MEW": "DITTO",
    "MOLTRES": "NINETALES",
    "MR__MIME": "HYPNO",
    "MR__RIME": "HYPNO",
    "MUNCHLAX": "KANGASKHAN",
    "OCTILLERY": "REMORAID",
    "OVERQWIL": "TENTACOOL",
    "PERRSERKER": "PERSIAN",
    "PIDGEOT": "NOCTOWL",
    "PIDGEOTTO": "HOOTHOOT",
    "PIDGEY": "HOOTHOOT",
    "PILOSWINE": "SEEL",
    "PINECO": "SPINARAK",
    "POLITOED": "POLIWHIRL",
    "POLIWAG": "KRABBY",
    "POLIWHIRL": "KINGLER",
    "POLIWRATH": "MACHOKE",
    "PRIMEAPE": "MACHOP",
    "PSYDUCK": "SLOWPOKE",
    "QWILFISH": "TENTACOOL",
    "RAIKOU": "LUXRAY",
    "REMORAID": "GOLDEEN",
    "SANDSHREW": "DIGLETT",
    "SANDSLASH": "DUGTRIO",
    "SCIZOR": "PAWNIARD",
    "SCYTHER": "PAWNIARD",
    "SHUCKLE": "HERACROSS",
    "SIRFETCH_D": "MADAME",
    "SMEARGLE": "DITTO",
    "SNORLAX": "KANGASKHAN",
    "SPEAROW": "HOOTHOOT",
    "SQUIRTLE": "HORSEA",
    "STANTLER": "MILTANK",
    "SUDOWOODO": "GEODUDE",
    "SUICUNE": "VAPOREON",
    "SWINUB": "SEEL",
    "TEDDIURSA": "PHANPY",
    "UNOWN": "DITTO",
    "URSALUNA": "URSARING",
    "URSARING": "PHANPY",
    "WARTORTLE": "SEADRA",
    "WEEDLE": "SPINARAK",
    "WIGGLYTUFF": "CLEFABLE",
    "WOBBUFFET": "DUNSPARCE",
    "WYRDEER": "GIRAFARIG",
    "YANMA": "NATU",
    "YANMEGA": "XATU",
    "ZAPDOS": "JOLTEON",
    "LUGIA": "LAPRAS",
    "HO_OH": "TYRANITAR",
    "CELEBI": "TOGEKISS",
}

# Targets still missing from regional dex -> final substitute
REGIONAL_FALLBACK: dict[str, str] = {
    "DELIBIRD": "HYPNO",
    "FORRETRESS": "PINECO",
    "MAROWAK": "CUBONE",
    "MUNCHLAX": "KANGASKHAN",
    "OCTILLERY": "REMORAID",
    "PINECO": "SPINARAK",
    "POLIWHIRL": "KINGLER",
    "REMORAID": "GOLDEEN",
    "SCIZOR": "PAWNIARD",
    "SHUCKLE": "HERACROSS",
    "STANTLER": "MILTANK",
    "SUDOWOODO": "GEODUDE",
    "SWINUB": "SEEL",
    "TEDDIURSA": "PHANPY",
    "WOBBUFFET": "DUNSPARCE",
    "CUBONE": "MAROWAK",
}


def file_to_regional_const(filename: str) -> str:
    base = filename.removesuffix(".asm")
    if base.endswith("_plain"):
        return base[: -len("_plain")].upper()
    if base.endswith("_hisuian"):
        return base.upper()
    if base.endswith("_galarian"):
        return base.upper()
    return base.upper()


def load_regional_constants() -> set[str]:
    return {file_to_regional_const(f) for f in load_regional_files()}


def add_learnsets() -> int:
    text = EVOS_ATTACKS.read_text()
    n = 0
    for label, additions in LEARNSET_ADD.items():
        block = re.search(
            rf"(evos_attacks {label}\n(?:\tevo_data[^\n]*\n)*)((?:\tlearnset[^\n]*\n)*)",
            text,
        )
        if not block:
            continue
        existing = block.group(2)
        new_lines = []
        for lvl, mv in additions:
            if re.search(rf"learnset {lvl}, {mv}", existing):
                continue
            new_lines.append(f"\tlearnset {lvl}, {mv}")
            n += 1
        if new_lines:
            insert = "".join(new_lines) + "\n"
            text = text[: block.end(2)] + insert + text[block.end(2) :]
    EVOS_ATTACKS.write_text(text)
    return n


def replace_legend_moves_in_learnsets() -> int:
    text = EVOS_ATTACKS.read_text()
    n = 0
    for old, new in LEARNSET_REPLACE.items():
        pat = rf"learnset (\d+), {old}"
        if re.search(pat, text):
            text, c = re.subn(pat, rf"learnset \1, {new}", text)
            n += c
    EVOS_ATTACKS.write_text(text)
    return n


def add_tmhm_moves() -> int:
    n = 0
    for fn, moves in TMHM_ADD.items():
        path = BASE_STATS_DIR / fn
        if not path.exists():
            continue
        text = path.read_text()
        m = re.search(r"(\ttmhm\s+)(.+?)(\n\t; end)", text, re.S)
        if not m:
            continue
        existing = {x.strip() for x in m.group(2).replace("\n", " ").split(",")}
        add = [mv for mv in moves if mv not in existing]
        if not add:
            continue
        new_tmhm = m.group(2).rstrip() + ", " + ", ".join(add)
        text = text[: m.start(2)] + new_tmhm + text[m.end(2) :]
        path.write_text(text)
        n += len(add)
    return n


def patch_battle_tower_moves() -> int:
    text = BATTLE_TOWER.read_text()
    n = 0
    for old, new in LEARNSET_REPLACE.items():
        cnt = text.count(old)
        if cnt:
            text = text.replace(old, new)
            n += cnt
    BATTLE_TOWER.write_text(text)
    return n


def patch_odd_eggs() -> None:
    text = ODD_EGGS.read_text()
    text = text.replace("AEROBLAST", "HURRICANE")
    ODD_EGGS.write_text(text)


def resolve_replacement(species: str, regional: set[str]) -> str | None:
    if species in regional:
        return None
    chain = [species]
    while chain:
        cur = chain[-1]
        nxt = REPLACEMENTS.get(cur) or REGIONAL_FALLBACK.get(cur)
        if not nxt or nxt in chain:
            break
        if nxt in regional:
            return nxt
        chain.append(nxt)
    for d in ("RATTATA", "SENTRET", "MAGIKARP", "DITTO", "LEDYBA"):
        if d in regional:
            return d
    return None


def encounter_species_match(line: str) -> re.Match[str] | None:
    """Return regex match whose group(1) is the species constant to replace."""
    skip_forms = {
        "MALE", "FEMALE", "PLAIN_FORM", "HISUIAN_FORM", "GALARIAN_FORM",
        "ALOLAN_FORM", "PALDEAN_FORM", "NO_ITEM", "KANTO_FORM", "JOHTO_FORM",
        "THREE_SEGMENT_FORM", "TWO_SEGMENT_FORM", "PALDEAN_FIRE_FORM",
        "PALDEAN_WATER_FORM", "PALDEAN_COMBAT_FORM",
    }
    for kind in ("tr_mon", "wildmon"):
        m = re.search(
            rf"\b{kind}\s+(?:LEVEL_FROM_BADGES[^,]*|\d+),\s*(?:\"[^\"]*\"\s*,\s*)?(\w+)",
            line,
        )
        if m and m.group(1) not in skip_forms:
            return m
    m = re.match(r"^\s*dp\s+(\w+)", line)
    if m and m.group(1) not in skip_forms:
        return m
    return None


def replace_encounters(regional: set[str]) -> dict[str, int]:
    stats: dict[str, int] = {}
    paths = list((ROOT / "data/trainers").rglob("*.asm"))
    paths += list((ROOT / "data/battle_tower").rglob("*.asm"))
    paths += list((ROOT / "data/wild").rglob("*.asm"))

    for path in paths:
        lines = path.read_text().splitlines(keepends=True)
        changed = False
        new_lines = []
        for line in lines:
            m = encounter_species_match(line)
            if not m:
                new_lines.append(line)
                continue
            sp = m.group(1)
            rep = resolve_replacement(sp, regional)
            if not rep or rep == sp:
                new_lines.append(line)
                continue
            new_line = line[: m.start(1)] + rep + line[m.end(1) :]
            stats[f"{sp}->{rep}"] = stats.get(f"{sp}->{rep}", 0) + 1
            changed = True
            new_lines.append(new_line)
        if changed:
            path.write_text("".join(new_lines))
    return stats


def main() -> None:
    regional = load_regional_constants()
    print(f"Regional dex: {len(regional)} species")

    n_learn = add_learnsets()
    n_legend = replace_legend_moves_in_learnsets()
    n_tm = add_tmhm_moves()
    n_bt = patch_battle_tower_moves()
    patch_odd_eggs()
    enc = replace_encounters(regional)

    print(f"Learnset additions: {n_learn}")
    print(f"Legend move replacements in learnsets: {n_legend}")
    print(f"TMHM additions: {n_tm}")
    print(f"Battle Tower move replacements: {n_bt}")
    print(f"Encounter replacements: {sum(enc.values())} ({len(enc)} unique maps)")
    for k, v in sorted(enc.items(), key=lambda x: -x[1])[:25]:
        print(f"  {k}: {v}")


if __name__ == "__main__":
    main()
