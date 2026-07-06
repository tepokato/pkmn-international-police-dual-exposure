#!/usr/bin/env python3
"""Compare Polished Crystal types/learnsets against Pokémon Scarlet/Violet (PokeAPI).

Usage:
  python3 tools/sv_sync.py report          # write tools/sv_sync/report.md + gaps.json
  python3 tools/sv_sync.py types           # type diff only (stdout summary)
  python3 tools/sv_sync.py apply-types     # patch base_stats/*.asm type lines

Defaults: base-game SV (version_group scarlet-violet), level-up learnsets only.
Custom species without a PokeAPI entry are listed as SKIP in the report.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import time
import urllib.error
import urllib.request
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE_STATS_DIR = ROOT / "data/pokemon/base_stats"
BASE_STATS_INDEX = ROOT / "data/pokemon/base_stats.asm"
REGIONAL_DEX = ROOT / "data/pokemon/regional_dex.txt"
TYPE_CONSTANTS = ROOT / "constants/type_constants.asm"
MOVE_CONSTANTS = ROOT / "constants/move_constants.asm"
EVOS_ATTACKS = ROOT / "data/pokemon/evos_attacks.asm"
OUT_DIR = ROOT / "tools/sv_sync"
CACHE_DIR = OUT_DIR / "cache"

VG_SV = "scarlet-violet"
# PokeAPI omits scarlet-violet level-up for many species; prefer newest available.
VG_PREFERENCE = (
    "scarlet-violet",
    "sword-shield",
    "ultra-sun-ultra-moon",
    "sun-moon",
    "omega-ruby-alpha-sapphire",
    "x-y",
)
USER_AGENT = "pkmn-international-police-sv-sync/1.0"

# Species with no SV analogue (ROM hack exclusives, etc.)
SKIP_SPECIES_FILES = {
    "madame.asm",
    "mewtwo_armored.asm",
    "egg.asm",
}

# Filename -> PokeAPI pokemon id (when heuristics are not enough)
API_NAME_OVERRIDES: dict[str, str] = {
    "tauros_paldean.asm": "tauros-paldea-combat-breed",
    "tauros_paldean_fire.asm": "tauros-paldea-blaze-breed",
    "tauros_paldean_water.asm": "tauros-paldea-aqua-breed",
    "ursaluna_bloodmoon.asm": "ursaluna-bloodmoon",
    "farfetch_d_plain.asm": "farfetchd",
    "farfetch_d_galarian.asm": "farfetchd-galar",
    "sirfetch_d.asm": "sirfetchd",
    "mime_jr_.asm": "mime-jr",
    "ho_oh.asm": "ho-oh",
    "mr__mime_plain.asm": "mr-mime",
    "mr__mime_galarian.asm": "mr-mime-galar",
    "mr__rime.asm": "mr-rime",
    "nidoran_f.asm": "nidoran-f",
    "nidoran_m.asm": "nidoran-m",
    "porygon_z.asm": "porygon-z",
    "wooper_paldean.asm": "wooper-paldea",
    "typhlosion_hisuian.asm": "typhlosion-hisui",
    "growlithe_hisuian.asm": "growlithe-hisui",
    "arcanine_hisuian.asm": "arcanine-hisui",
    "voltorb_hisuian.asm": "voltorb-hisui",
    "electrode_hisuian.asm": "electrode-hisui",
    "qwilfish_hisuian.asm": "qwilfish-hisui",
    "sneasel_hisuian.asm": "sneasel-hisui",
    "articuno_galarian.asm": "articuno-galar",
    "zapdos_galarian.asm": "zapdos-galar",
    "moltres_galarian.asm": "moltres-galar",
    "slowking_galarian.asm": "slowking-galar",
    "slowbro_galarian.asm": "slowbro-galar",
    "slowpoke_galarian.asm": "slowpoke-galar",
    "corsola_galarian.asm": "corsola-galar",
    "weezing_galarian.asm": "weezing-galar",
    "ponyta_galarian.asm": "ponyta-galar",
    "rapidash_galarian.asm": "rapidash-galar",
    "meowth_galarian.asm": "meowth-galar",
    "perrserker.asm": "perrserker",
    "cursola.asm": "cursola",
    "clodsire.asm": "clodsire",
    "annihilape.asm": "annihilape",
    "farigiraf.asm": "farigiraf",
    "wyrdeer.asm": "wyrdeer",
    "kleavor.asm": "kleavor",
    "sneasler.asm": "sneasler",
    "overqwil.asm": "overqwil",
    "dudunsparce.asm": "dudunsparce",
    "kingambit.asm": "kingambit",
    "gardevoir.asm": "gardevoir",
    "gallade.asm": "gallade",
    "hawlucha.asm": "hawlucha",
    "pawniard.asm": "pawniard",
    "bisharp.asm": "bisharp",
}

# PokeAPI move name -> ROM constant (exceptions)
MOVE_API_OVERRIDES: dict[str, str] = {
    "swords-dance": "SWORDS_DANCE",
    "double-slap": "DOUBLE_SLAP",
    "pay-day": "PAY_DAY",
    "fire-punch": "FIRE_PUNCH",
    "ice-punch": "ICE_PUNCH",
    "thunder-punch": "THUNDERPUNCH",
    "vice-grip": "VICE_GRIP",  # not in ROM; will show as missing
    "x-scissor": "X_SCISSOR",
    "aerial-ace": "AERIAL_ACE",
    "dragon-claw": "DRAGON_CLAW",
    "night-slash": "NIGHT_SLASH",
    "air-slash": "AIR_SLASH",
    "sucker-punch": "SUCKER_PUNCH",
    "dazzling-gleam": "DAZZZLINGLEAM",
    "volt-switch": "VOLT_SWITCH",
    "vine-whip": "VINE_WHIP",
    "double-kick": "DOUBLE_KICK",
    "flare-blitz": "FLARE_BLITZ",
    "stone-edge": "STONE_EDGE",
    "focus-blast": "FOCUS_BLAST",
    "toxic-spikes": "TOXIC_SPIKES",
    "horn-attack": "HORN_ATTACK",
    "body-slam": "BODY_SLAM",
    "take-down": "TAKE_DOWN",
    "double-edge": "DOUBLE_EDGE",
    "poison-sting": "POISON_STING",
    "u-turn": "U_TURN",
    "pin-missile": "PIN_MISSILE",
    "sonic-boom": "SONIC_BOOM",
    "water-gun": "WATER_GUN",
    "hydro-pump": "HYDRO_PUMP",
    "ice-beam": "ICE_BEAM",
    "bubble-beam": "BUBBLE_BEAM",
    "aurora-beam": "AURORA_BEAM",
    "hyper-beam": "HYPER_BEAM",
    "drill-peck": "DRILL_PECK",
    "close-combat": "CLOSE_COMBAT",
    "low-kick": "LOW_KICK",
    "seismic-toss": "SEISMIC_TOSS",
    "mega-drain": "MEGA_DRAIN",
    "leech-seed": "LEECH_SEED",
    "razor-leaf": "RAZOR_LEAF",
    "solar-beam": "SOLAR_BEAM",
    "poison-powder": "POISONPOWDER",
    "stun-spore": "STUN_SPORE",
    "sleep-powder": "SLEEP_POWDER",
    "petal-dance": "PETAL_DANCE",
    "string-shot": "STRING_SHOT",
    "dragon-rage": "DRAGON_RAGE",
    "fire-spin": "FIRE_SPIN",
    "thunder-shock": "THUNDERSHOCK",
    "thunder-wave": "THUNDER_WAVE",
    "rock-throw": "ROCK_THROW",
    "quick-attack": "QUICK_ATTACK",
    "night-shade": "NIGHT_SHADE",
    "dragon-pulse": "DRAGON_PULSE",
    "double-team": "DOUBLE_TEAM",
    "rock-blast": "ROCK_BLAST",
    "confuse-ray": "CONFUSE_RAY",
    "aqua-tail": "AQUA_TAIL",
    "defense-curl": "DEFENSE_CURL",
    "light-screen": "LIGHT_SCREEN",
    "flash-cannon": "FLASH_CANNON",
    "trick-room": "TRICK_ROOM",
    "skill-swap": "SKILL_SWAP",
    "gunk-shot": "GUNK_SHOT",
    "earth-power": "EARTH_POWER",
    "fire-blast": "FIRE_BLAST",
    "icicle-crash": "ICICLE_CRASH",
    "iron-head": "IRON_HEAD",
    "icicle-spear": "ICICLE_SPEAR",
    "hi-jump-kick": "HI_JUMP_KICK",
    "dream-eater": "DREAM_EATER",
    "poison-jab": "POISON_JAB",
    "bullet-punch": "BULLET_PUNCH",
    "leech-life": "LEECH_LIFE",
    "draining-kiss": "DRAINING_KISS",
    "brave-bird": "BRAVE_BIRD",
    "water-pulse": "WATER_PULSE",
    "dizzy-punch": "DIZZY_PUNCH",
    "dragon-dance": "DRAGON_DANCE",
    "fury-swipes": "FURY_STRIKES",
    "rock-slide": "ROCK_SLIDE",
    "hyper-fang": "PAYBACK",
    "brick-break": "BRICK_BREAK",
    "discharge": "DISCHARGE",
    "focus-energy": "FOCUS_ENERGY",
    "payback": "PAYBACK",
    "bulk-up": "BULK_UP",
    "tri-attack": "TRI_ATTACK",
    "super-fang": "SUPER_FANG",
    "giga-impact": "GIGA_IMPACT",
    "drain-punch": "DRAIN_PUNCH",
    "will-o-wisp": "WILL_O_WISP",
    "zen-headbutt": "ZEN_HEADBUTT",
    "flame-charge": "FLAME_CHARGE",
    "hyper-voice": "HYPER_VOICE",
    "energy-ball": "ENERGY_BALL",
    "seed-bomb": "SEED_BOMB",
    "ice-shard": "ICE_SHARD",
    "mach-punch": "MACH_PUNCH",
    "scary-face": "SCARY_FACE",
    "feint-attack": "FEINT_ATTACK",
    "sweet-kiss": "SWEET_KISS",
    "belly-drum": "BELLY_DRUM",
    "sludge-bomb": "SLUDGE_BOMB",
    "mud-slap": "MUD_SLAP",
    "stealth-rock": "STEALTH_ROCK",
    "heal-block": "HEAL_BLOCK",
    "destiny-bond": "DESTINY_BOND",
    "perish-song": "PERISH_SONG",
    "icy-wind": "ICY_WIND",
    "power-gem": "POWER_GEM",
    "wild-charge": "WILD_CHARGE",
    "power-whip": "POWER_WHIP",
    "giga-drain": "GIGA_DRAIN",
    "false-swipe": "FALSE_SWIPE",
    "shell-smash": "SHELL_SMASH",
    "steel-wing": "STEEL_WING",
    "mean-look": "MEAN_LOOK",
    "sleep-talk": "SLEEP_TALK",
    "heal-bell": "HEAL_BELL",
    "bug-buzz": "BUG_BUZZ",
    "sacred-fire": "DISCHARGE",
    "dynamic-punch": "DYNAMICPUNCH",
    "dragon-breath": "DRAGONBREATH",
    "baton-pass": "BATON_PASS",
    "rapid-spin": "RAPID_SPIN",
    "shadow-claw": "SHADOW_CLAW",
    "iron-tail": "IRON_TAIL",
    "metal-claw": "METAL_CLAW",
    "aura-sphere": "AURA_SPHERE",
    "knock-off": "KNOCK_OFF",
    "hidden-power": "HIDDEN_POWER",
    "cross-chop": "CROSS_CHOP",
    "aqua-jet": "AQUA_JET",
    "rain-dance": "RAIN_DANCE",
    "sunny-day": "SUNNY_DAY",
    "mirror-coat": "MIRROR_COAT",
    "nasty-plot": "NASTY_PLOT",
    "extreme-speed": "EXTREMESPEED",
    "ancient-power": "ANCIENTPOWER",
    "shadow-ball": "SHADOW_BALL",
    "future-sight": "FUTURE_SIGHT",
    "rock-smash": "BRICK_BREAK",
    "rock-tomb": "ROCK_TOMB",
    "sacred-sword": "SACRED_SWORD",
    "dark-pulse": "DARK_PULSE",
    "play-rough": "PLAY_ROUGH",
    "disarming-voice": "DISARM_VOICE",
    "fresh-snack": "FRESH_SNACK",
    "healing-light": "HEALINGLIGHT",
    "psychic": "PSYCHIC_M",
}


def api_get(url: str) -> dict:
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    key = re.sub(r"[^a-zA-Z0-9]", "_", url)
    cache = CACHE_DIR / f"{key}.json"
    if cache.exists():
        return json.loads(cache.read_text())
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    for attempt in range(4):
        try:
            with urllib.request.urlopen(req, timeout=30) as resp:
                data = json.loads(resp.read().decode())
            cache.write_text(json.dumps(data))
            return data
        except urllib.error.HTTPError as e:
            if e.code == 404:
                raise
            if e.code == 429:
                time.sleep(2 ** attempt)
                continue
            raise
        except urllib.error.URLError:
            time.sleep(2 ** attempt)
    raise RuntimeError(f"Failed to fetch {url}")


def parse_type_constants() -> dict[str, str]:
    types: dict[str, str] = {}
    for line in TYPE_CONSTANTS.read_text().splitlines():
        m = re.match(r"\s*const\s+(\w+)\s*;", line)
        if m:
            types[m.group(1)] = m.group(1).lower()
    types["UNKNOWN_T"] = "unknown"
    return types


def parse_move_constants() -> set[str]:
    moves: set[str] = set()
    for line in MOVE_CONSTANTS.read_text().splitlines():
        m = re.match(r"\s*const\s+(\w+)\s*;", line)
        if m and m.group(1) not in ("NO_MOVE",):
            moves.add(m.group(1))
    return moves


def rom_moves_to_api_index(rom_moves: set[str]) -> dict[str, str]:
    """ROM constant -> pokeapi kebab (best effort)."""
    idx: dict[str, str] = {}
    for mv in rom_moves:
        if mv in ("STRUGGLE",):
            continue
        kebab = mv.lower().replace("_", "-")
        idx[mv] = kebab
    for api, rom in MOVE_API_OVERRIDES.items():
        if rom in rom_moves:
            idx[rom] = api
    return {rom: api for rom, api in idx.items()}


def api_to_rom(api_name: str, rom_moves: set[str]) -> str | None:
    if api_name in MOVE_API_OVERRIDES:
        rom = MOVE_API_OVERRIDES[api_name]
        return rom if rom in rom_moves else None
    cand = api_name.upper().replace("-", "_")
    if cand in rom_moves:
        return cand
    # THUNDERSHOCK style
    alt = cand.replace("_", "")
    for mv in rom_moves:
        if mv.replace("_", "") == alt:
            return mv
    return None


@dataclass
class RegionalDex:
    """Species in scope for this ROM hack (see data/pokemon/regional_dex.txt)."""

    in_rom: set[str]  # base_stats filenames implemented and in dex
    planned: list[str]  # filenames in dex but not yet in ROM


def load_regional_dex() -> RegionalDex | None:
    if not REGIONAL_DEX.exists():
        return None
    in_rom: set[str] = set()
    planned: list[str] = []
    for line in REGIONAL_DEX.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        planned_flag = line.upper().startswith("PLANNED ")
        entry = line.removeprefix("PLANNED ").strip()
        entry = entry.split(";", 1)[0].strip()
        if not entry:
            continue
        path = BASE_STATS_DIR / entry
        if path.exists():
            in_rom.add(entry)
        elif planned_flag:
            planned.append(entry)
    return RegionalDex(in_rom=in_rom, planned=planned)


def list_base_stat_files(regional: RegionalDex | None = None) -> list[str]:
    files: list[str] = []
    for line in BASE_STATS_INDEX.read_text().splitlines():
        m = re.search(r'INCLUDE "data/pokemon/base_stats/([^"]+)"', line)
        if m:
            files.append(m.group(1))
    if regional is not None:
        files = [fn for fn in files if fn in regional.in_rom]
    return files


def filename_to_api_name(filename: str) -> str | None:
    if filename in SKIP_SPECIES_FILES:
        return None
    if filename in API_NAME_OVERRIDES:
        return API_NAME_OVERRIDES[filename]
    base = filename.removesuffix(".asm")
    if base.endswith("_plain"):
        base = base[: -len("_plain")]
    elif base.endswith("_alolan"):
        return base[: -len("_alolan")].replace("__", "_") + "-alola"
    elif base.endswith("_galarian"):
        return base[: -len("_galarian")].replace("__", "_") + "-galar"
    elif base.endswith("_hisuian"):
        return base[: -len("_hisuian")].replace("__", "_") + "-hisui"
    elif base.endswith("_paldean"):
        return base[: -len("_paldean")].replace("__", "_") + "-paldea"
    name = base.replace("__", "-").replace("_", "-")
    # fix double hyphens from mr--mime etc.
    name = re.sub(r"-+", "-", name)
    return name


def normalize_local_types(local: tuple[str, str], type_const: dict[str, str]) -> list[str]:
    t1 = type_const.get(local[0], local[0].lower())
    t2 = type_const.get(local[1], local[1].lower())
    if t1 == t2:
        return [t1]
    return [t1, t2]


def types_match(local: tuple[str, str], sv: list[str], type_const: dict[str, str]) -> tuple[bool, str]:
    """Return (matches, status_detail)."""
    local_n = normalize_local_types(local, type_const)
    if local_n == sv:
        return True, "ok"
    if sorted(local_n) == sorted(sv):
        return False, "order"
    return False, "mismatch"


def read_local_types(path: Path) -> tuple[str, str] | None:
    text = path.read_text()
    for line in text.splitlines():
        m = re.match(r"\s*db\s+(\w+)\s*,\s*(\w+)\s*;\s*type", line)
        if m:
            return m.group(1), m.group(2)
    return None


def fetch_sv_types(api_name: str) -> list[str] | None:
    try:
        data = api_get(f"https://pokeapi.co/api/v2/pokemon/{api_name}")
    except urllib.error.HTTPError as e:
        if e.code == 404:
            return None
        raise
    return [t["type"]["name"] for t in sorted(data["types"], key=lambda x: x["slot"])]


def fetch_sv_level_moves(api_name: str) -> list[tuple[int, str]]:
    data = api_get(f"https://pokeapi.co/api/v2/pokemon/{api_name}")
    for vg in VG_PREFERENCE:
        best: dict[str, int] = {}
        for entry in data["moves"]:
            move = entry["move"]["name"]
            for detail in entry["version_group_details"]:
                if (
                    detail["version_group"]["name"] == vg
                    and detail["move_learn_method"]["name"] == "level-up"
                ):
                    lvl = detail["level_learned_at"]
                    if move not in best or lvl < best[move]:
                        best[move] = lvl
        if best:
            return sorted(
                ((lvl, mv) for mv, lvl in best.items()), key=lambda x: (x[0], x[1])
            )
    return []


def parse_learnsets() -> dict[str, list[tuple[int, str]]]:
    """evos_attacks label (e.g. Bulbasaur) -> [(level, MOVE)]."""
    text = EVOS_ATTACKS.read_text()
    sets: dict[str, list[tuple[int, str]]] = {}
    current: str | None = None
    for line in text.splitlines():
        m = re.match(r"\s*evos_attacks\s+(\w+)", line)
        if m:
            current = m.group(1)
            sets[current] = []
            continue
        m = re.match(r"\s*learnset\s+(\d+)\s*,\s*(\w+)", line)
        if m and current:
            sets[current].append((int(m.group(1)), m.group(2)))
    return sets


def evos_label_for_file(filename: str) -> str:
    """Map base_stats filename to evos_attacks label."""
    base = filename.removesuffix(".asm")
    return "".join(p.capitalize() for p in base.split("_"))


@dataclass
class TypeDiff:
    file: str
    api_name: str | None
    local: tuple[str, str] | None
    sv: list[str] | None
    status: str  # ok, order, mismatch, skip, missing_api, missing_local


@dataclass
class LearnsetDiff:
    label: str
    api_name: str | None
    missing_in_rom: list[str] = field(default_factory=list)
    extra_in_rom: list[str] = field(default_factory=list)
    unmapped_sv_moves: list[str] = field(default_factory=list)
    level_mismatches: list[str] = field(default_factory=list)


def compare_types(regional: RegionalDex | None = None) -> list[TypeDiff]:
    type_const = parse_type_constants()
    diffs: list[TypeDiff] = []
    for fn in list_base_stat_files(regional):
        if fn in SKIP_SPECIES_FILES:
            diffs.append(TypeDiff(fn, None, read_local_types(BASE_STATS_DIR / fn), None, "skip"))
            continue
        api = filename_to_api_name(fn)
        local = read_local_types(BASE_STATS_DIR / fn)
        if not local:
            diffs.append(TypeDiff(fn, api, None, None, "missing_local"))
            continue
        if not api:
            diffs.append(TypeDiff(fn, None, local, None, "skip"))
            continue
        sv = fetch_sv_types(api)
        if sv is None:
            diffs.append(TypeDiff(fn, api, local, None, "missing_api"))
            continue
        match, detail = types_match(local, sv, type_const)
        if match:
            diffs.append(TypeDiff(fn, api, local, sv, "ok"))
        else:
            diffs.append(TypeDiff(fn, api, local, sv, detail))
    return diffs


def compare_learnsets(
    rom_moves: set[str], regional: RegionalDex | None = None
) -> list[LearnsetDiff]:
    learnsets = parse_learnsets()
    diffs: list[LearnsetDiff] = []
    seen_labels: set[str] = set()
    for fn in list_base_stat_files(regional):
        if fn in SKIP_SPECIES_FILES:
            continue
        api = filename_to_api_name(fn)
        if not api:
            continue
        label = evos_label_for_file(fn)
        if label in seen_labels:
            continue
        seen_labels.add(label)
        if label not in learnsets:
            continue
        local = learnsets[label]
        try:
            sv = fetch_sv_level_moves(api)
        except urllib.error.HTTPError:
            continue
        ld = LearnsetDiff(label, api)
        sv_by_rom: dict[str, int] = {}
        for lvl, api_mv in sv:
            rom = api_to_rom(api_mv, rom_moves)
            if rom is None:
                ld.unmapped_sv_moves.append(api_mv)
            else:
                sv_by_rom[rom] = lvl
        local_map = {mv: lvl for lvl, mv in local}
        for rom, lvl in sv_by_rom.items():
            if rom not in local_map:
                ld.missing_in_rom.append(f"L{lvl} {rom} ({api_to_rom_name(rom)})")
        for rom, lvl in local_map.items():
            if rom not in sv_by_rom:
                ld.extra_in_rom.append(f"L{lvl} {rom}")
            elif sv_by_rom[rom] != lvl:
                ld.level_mismatches.append(f"{rom}: ROM L{lvl} vs SV L{sv_by_rom[rom]}")
        if ld.missing_in_rom or ld.extra_in_rom or ld.unmapped_sv_moves or ld.level_mismatches:
            diffs.append(ld)
    return diffs


def api_to_rom_name(rom: str) -> str:
    for api, r in MOVE_API_OVERRIDES.items():
        if r == rom:
            return api
    return rom.lower().replace("_", "-")


def apply_type_fixes(diffs: list[TypeDiff], type_const: dict[str, str]) -> int:
  rev = {v: k for k, v in type_const.items() if k != "UNKNOWN_T"}
  # also allow direct
  for k in type_const:
      rev[type_const[k]] = k
  patched = 0
  for d in diffs:
      if d.status not in ("mismatch", "order") or not d.sv or not d.local:
          continue
      t1 = rev.get(d.sv[0], d.sv[0].upper())
      t2 = rev.get(d.sv[1], d.sv[1].upper()) if len(d.sv) > 1 else t1
      path = BASE_STATS_DIR / d.file
      text = path.read_text()
      new_line = f"\tdb {t1}, {t2} ; type"
      new_text, n = re.subn(
          r"\tdb\s+\w+\s*,\s*\w+\s*;\s*type",
          new_line,
          text,
          count=1,
      )
      if n:
          path.write_text(new_text)
          patched += 1
          print(f"Patched {d.file}: {d.local} -> ({t1}, {t2})")
  return patched


def write_report(
    type_diffs: list[TypeDiff],
    learn_diffs: list[LearnsetDiff],
    rom_moves: set[str],
    regional: RegionalDex | None = None,
) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    mismatches = [d for d in type_diffs if d.status == "mismatch"]
    order_only = [d for d in type_diffs if d.status == "order"]
    missing_api = [d for d in type_diffs if d.status == "missing_api"]
    ok = sum(1 for d in type_diffs if d.status == "ok")
    unmapped: set[str] = set()
    for ld in learn_diffs:
        unmapped.update(ld.unmapped_sv_moves)

    lines = [
        "# Scarlet/Violet sync report",
        "",
        f"Generated by `tools/sv_sync.py`. Version group: **{VG_SV}**.",
        "",
    ]
    if regional is not None:
        lines += [
            f"Scoped to **regional dex** (`data/pokemon/regional_dex.txt`): "
            f"**{len(regional.in_rom)}** species in ROM, "
            f"**{len(regional.planned)}** planned (not yet implemented).",
            "",
        ]
        if regional.planned:
            lines.append("### Planned species (not in ROM yet)")
            lines.append("")
            for fn in regional.planned:
                lines.append(f"- `{fn}`")
            lines.append("")
    lines += [
        "## Summary",
        "",
        f"- Types OK: **{ok}**",
        f"- Type mismatches (wrong types): **{len(mismatches)}**",
        f"- Type order only (same types, wrong primary): **{len(order_only)}**",
        f"- No PokeAPI entry (manual review): **{len(missing_api)}**",
        f"- Learnsets with differences: **{len(learn_diffs)}**",
        f"- SV moves not in ROM: **{len(unmapped)}** unique",
        "",
        "## Type mismatches",
        "",
    ]
    if mismatches:
        lines.append("| File | API | Local | SV |")
        lines.append("|------|-----|-------|-----|")
        for d in mismatches:
            lines.append(f"| `{d.file}` | `{d.api_name}` | `{d.local}` | `{d.sv}` |")
    else:
        lines.append("_None — all compared types match SV._")

    lines += ["", "## Type order (primary/secondary)", ""]
    if order_only:
        lines.append("| File | API | Local | SV |")
        lines.append("|------|-----|-------|-----|")
        for d in order_only:
            lines.append(f"| `{d.file}` | `{d.api_name}` | `{d.local}` | `{d.sv}` |")
    else:
        lines.append("_None._")

    lines += ["", "## Missing PokeAPI mapping", ""]
    if missing_api:
        for d in missing_api:
            lines.append(f"- `{d.file}` (tried `{d.api_name}`) local `{d.local}`")
    else:
        lines.append("_None._")

    lines += ["", "## SV moves not present in ROM", ""]
    if unmapped:
        for mv in sorted(unmapped):
            lines.append(f"- `{mv}`")
    else:
        lines.append("_None._")

    lines += ["", "## Learnset diffs (first 40 species)", ""]
    for ld in learn_diffs[:40]:
        lines.append(f"### {ld.label} (`{ld.api_name}`)")
        if ld.unmapped_sv_moves:
            lines.append(f"- Unmapped SV: {', '.join(f'`{m}`' for m in sorted(set(ld.unmapped_sv_moves))[:12])}")
        if ld.missing_in_rom:
            lines.append("- Missing in ROM:")
            for x in ld.missing_in_rom[:15]:
                lines.append(f"  - {x}")
            if len(ld.missing_in_rom) > 15:
                lines.append(f"  - … +{len(ld.missing_in_rom) - 15} more")
        if ld.extra_in_rom:
            lines.append("- Extra in ROM (not SV level-up):")
            for x in ld.extra_in_rom[:10]:
                lines.append(f"  - {x}")
        if ld.level_mismatches:
            lines.append("- Level mismatches:")
            for x in ld.level_mismatches[:10]:
                lines.append(f"  - {x}")
        lines.append("")

    if len(learn_diffs) > 40:
        lines.append(f"_… and {len(learn_diffs) - 40} more species in `gaps.json`._")

    (OUT_DIR / "report.md").write_text("\n".join(lines) + "\n")

    gaps = {
        "type_mismatches": [
            {"file": d.file, "api": d.api_name, "local": d.local, "sv": d.sv}
            for d in mismatches
        ],
        "type_order": [
            {"file": d.file, "api": d.api_name, "local": d.local, "sv": d.sv}
            for d in order_only
        ],
        "missing_api": [
            {"file": d.file, "api": d.api_name, "local": d.local} for d in missing_api
        ],
        "unmapped_sv_moves": sorted(unmapped),
        "learnset_diffs": [
            {
                "label": ld.label,
                "api": ld.api_name,
                "missing_in_rom": ld.missing_in_rom,
                "extra_in_rom": ld.extra_in_rom,
                "level_mismatches": ld.level_mismatches,
                "unmapped_sv_moves": ld.unmapped_sv_moves,
            }
            for ld in learn_diffs
        ],
    }
    (OUT_DIR / "gaps.json").write_text(json.dumps(gaps, indent=2) + "\n")
    print(f"Wrote {OUT_DIR / 'report.md'}")
    print(f"Wrote {OUT_DIR / 'gaps.json'}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "command",
        choices=("report", "types", "apply-types"),
        help="report=full markdown; types=summary; apply-types=patch mismatches",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="compare every species in the ROM (ignore regional_dex.txt)",
    )
    args = parser.parse_args()

    print("Loading local data…")
    type_const = parse_type_constants()
    rom_moves = parse_move_constants()
    regional = None if args.all else load_regional_dex()
    if regional is not None:
        print(
            f"Regional dex: {len(regional.in_rom)} in ROM, "
            f"{len(regional.planned)} planned"
        )
    elif not args.all:
        print("No regional_dex.txt — comparing full ROM.")

    print("Fetching / comparing types (cached in tools/sv_sync/cache)…")
    type_diffs = compare_types(regional)
    mismatches = [d for d in type_diffs if d.status == "mismatch"]
    order_only = [d for d in type_diffs if d.status == "order"]
    ok = sum(1 for d in type_diffs if d.status == "ok")
    print(f"Types: {ok} OK, {len(mismatches)} mismatches, {len(order_only)} order-only")

    if args.command == "types":
        for d in mismatches:
            print(f"  {d.file}: local {d.local} vs SV {d.sv} ({d.api_name})")
        return 0

    print("Comparing level-up learnsets…")
    learn_diffs = compare_learnsets(rom_moves, regional)
    print(f"Learnsets with diffs: {len(learn_diffs)}")

    if args.command == "report":
        write_report(type_diffs, learn_diffs, rom_moves, regional)
        return 0

    if args.command == "apply-types":
        n = apply_type_fixes(type_diffs, type_const)
        print(f"Applied {n} type patches.")
        return 0

    return 0


if __name__ == "__main__":
    sys.exit(main())
