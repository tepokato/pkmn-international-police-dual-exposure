#!/usr/bin/env python3
"""Add PLANNED regional-dex species with placeholder graphics."""

from __future__ import annotations

import json
import re
import shutil
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGIONAL_DEX = ROOT / "data/pokemon/regional_dex.txt"
BASE_STATS_DIR = ROOT / "data/pokemon/base_stats"
GFX_DIR = ROOT / "gfx/pokemon"
FOOTPRINT_DIR = ROOT / "gfx/footprints"
MINI_DIR = ROOT / "gfx/minis"
ICON_DIR = ROOT / "gfx/icons"
CACHE = ROOT / "tools/sv_sync/cache"

PLACEHOLDER_GFX: dict[str, str] = {
    "ralts.asm": "abra",
    "kirlia.asm": "kadabra",
    "gardevoir.asm": "alakazam",
    "gallade.asm": "scyther",
    "poochyena.asm": "houndour",
    "mightyena.asm": "houndoom",
    "zigzagoon.asm": "sentret",
    "linoone.asm": "furret",
    "aron.asm": "magnemite",
    "lairon.asm": "magneton",
    "aggron.asm": "golem_plain",
    "trapinch.asm": "larvitar",
    "vibrava.asm": "pupitar",
    "flygon.asm": "dragonite",
    "cacnea.asm": "oddish",
    "cacturne.asm": "victreebel",
    "baltoy.asm": "magnemite",
    "claydol.asm": "magneton",
    "absol.asm": "sneasel_plain",
    "bagon.asm": "dratini",
    "shelgon.asm": "dragonair",
    "salamence.asm": "dragonite",
    "beldum.asm": "magnemite",
    "metang.asm": "magneton",
    "metagross.asm": "magnezone",
    "shinx.asm": "pichu",
    "luxio.asm": "pikachu",
    "luxray.asm": "raichu_plain",
    "stunky.asm": "koffing",
    "skuntank.asm": "weezing_plain",
    "bronzor.asm": "magnemite",
    "bronzong.asm": "magneton",
    "riolu.asm": "machop",
    "lucario.asm": "machamp",
    "skorupi.asm": "paras",
    "drapion.asm": "parasect",
    "croagunk.asm": "machop",
    "toxicroak.asm": "machamp",
    "rotom.asm": "porygon",
    "lillipup.asm": "growlithe_plain",
    "herdier.asm": "growlithe_plain",
    "stoutland.asm": "arcanine_plain",
    "purrloin.asm": "meowth_plain",
    "liepard.asm": "persian_plain",
    "audino.asm": "chansey",
    "trubbish.asm": "grimer_plain",
    "garbodor.asm": "muk_plain",
    "klink.asm": "magnemite",
    "klang.asm": "magneton",
    "klinklang.asm": "magnezone",
    "elgyem.asm": "natu",
    "beheeyem.asm": "xatu",
    "pawniard.asm": "scyther",
    "bisharp.asm": "scizor",
    "kingambit.asm": "honchkrow",
    "hawlucha.asm": "hitmonlee",
}

EGG_MOVE_SOURCE: dict[str, str] = {
    "ralts.asm": "Abra",
    "kirlia.asm": "Abra",
    "gardevoir.asm": "Abra",
    "gallade.asm": "Scyther",
    "poochyena.asm": "Houndour",
    "mightyena.asm": "Houndour",
    "zigzagoon.asm": "Sentret",
    "linoone.asm": "Sentret",
    "aron.asm": "Magnemite",
    "lairon.asm": "Magnemite",
    "aggron.asm": "Magnemite",
    "trapinch.asm": "Larvitar",
    "vibrava.asm": "Larvitar",
    "flygon.asm": "Larvitar",
    "cacnea.asm": "Oddish",
    "cacturne.asm": "Oddish",
    "baltoy.asm": "Magnemite",
    "claydol.asm": "Magnemite",
    "absol.asm": "Sneasel",
    "bagon.asm": "Dratini",
    "shelgon.asm": "Dratini",
    "salamence.asm": "Dratini",
    "beldum.asm": "Magnemite",
    "metang.asm": "Magnemite",
    "metagross.asm": "Magnemite",
    "shinx.asm": "Pichu",
    "luxio.asm": "Pichu",
    "luxray.asm": "Pichu",
    "stunky.asm": "Koffing",
    "skuntank.asm": "Koffing",
    "bronzor.asm": "Magnemite",
    "bronzong.asm": "Magnemite",
    "riolu.asm": "Machop",
    "lucario.asm": "Machop",
    "skorupi.asm": "Paras",
    "drapion.asm": "Paras",
    "croagunk.asm": "Machop",
    "toxicroak.asm": "Machop",
    "rotom.asm": "Porygon",
    "lillipup.asm": "GrowlithePlain",
    "herdier.asm": "GrowlithePlain",
    "stoutland.asm": "GrowlithePlain",
    "purrloin.asm": "MeowthPlain",
    "liepard.asm": "MeowthPlain",
    "audino.asm": "Chansey",
    "trubbish.asm": "GrimerPlain",
    "garbodor.asm": "GrimerPlain",
    "klink.asm": "Magnemite",
    "klang.asm": "Magnemite",
    "klinklang.asm": "Magnemite",
    "elgyem.asm": "Natu",
    "beheeyem.asm": "Natu",
    "pawniard.asm": "Scyther",
    "bisharp.asm": "Scyther",
    "kingambit.asm": "Scyther",
    "hawlucha.asm": "Hitmonlee",
}

EVOLUTIONS: dict[str, list[tuple]] = {
    "ralts.asm": [("EVOLVE_LEVEL", 20, "KIRLIA")],
    "kirlia.asm": [
        ("EVOLVE_LEVEL", 30, "GARDEVOIR"),
        ("EVOLVE_ITEM", "SHINY_STONE", "GALLADE"),
    ],
    "poochyena.asm": [("EVOLVE_LEVEL", 18, "MIGHTYENA")],
    "zigzagoon.asm": [("EVOLVE_LEVEL", 20, "LINOONE")],
    "aron.asm": [("EVOLVE_LEVEL", 32, "LAIRON")],
    "lairon.asm": [("EVOLVE_LEVEL", 42, "AGGRON")],
    "trapinch.asm": [("EVOLVE_LEVEL", 35, "VIBRAVA")],
    "vibrava.asm": [("EVOLVE_LEVEL", 45, "FLYGON")],
    "cacnea.asm": [("EVOLVE_LEVEL", 32, "CACTURNE")],
    "baltoy.asm": [("EVOLVE_LEVEL", 36, "CLAYDOL")],
    "bagon.asm": [("EVOLVE_LEVEL", 30, "SHELGON")],
    "shelgon.asm": [("EVOLVE_LEVEL", 50, "SALAMENCE")],
    "beldum.asm": [("EVOLVE_LEVEL", 20, "METANG")],
    "metang.asm": [("EVOLVE_LEVEL", 45, "METAGROSS")],
    "shinx.asm": [("EVOLVE_LEVEL", 15, "LUXIO")],
    "luxio.asm": [("EVOLVE_LEVEL", 30, "LUXRAY")],
    "stunky.asm": [("EVOLVE_LEVEL", 34, "SKUNTANK")],
    "bronzor.asm": [("EVOLVE_LEVEL", 33, "BRONZONG")],
    "riolu.asm": [("EVOLVE_LEVEL", 25, "LUCARIO")],
    "skorupi.asm": [("EVOLVE_LEVEL", 40, "DRAPION")],
    "croagunk.asm": [("EVOLVE_LEVEL", 37, "TOXICROAK")],
    "lillipup.asm": [("EVOLVE_LEVEL", 16, "HERDIER")],
    "herdier.asm": [("EVOLVE_LEVEL", 32, "STOUTLAND")],
    "purrloin.asm": [("EVOLVE_LEVEL", 20, "LIEPARD")],
    "trubbish.asm": [("EVOLVE_LEVEL", 36, "GARBODOR")],
    "klink.asm": [("EVOLVE_LEVEL", 38, "KLANG")],
    "klang.asm": [("EVOLVE_LEVEL", 49, "KLINKLANG")],
    "elgyem.asm": [("EVOLVE_LEVEL", 42, "BEHEEYEM")],
    "pawniard.asm": [("EVOLVE_LEVEL", 52, "BISHARP")],
    "bisharp.asm": [("EVOLVE_LEVEL", 52, "KINGAMBIT")],
}

API_OVERRIDES = {
    "farfetch_d_plain": "farfetchd",
    "mime_jr_": "mime-jr",
    "ho_oh": "ho-oh",
    "porygon_z": "porygon-z",
    "nidoran_f": "nidoran-f",
    "nidoran_m": "nidoran-m",
}

TYPE_MAP = {
    "normal": "NORMAL",
    "fire": "FIRE",
    "water": "WATER",
    "electric": "ELECTRIC",
    "grass": "GRASS",
    "ice": "ICE",
    "fighting": "FIGHTING",
    "poison": "POISON",
    "ground": "GROUND",
    "flying": "FLYING",
    "psychic": "PSYCHIC",
    "bug": "BUG",
    "rock": "ROCK",
    "ghost": "GHOST",
    "dragon": "DRAGON",
    "dark": "DARK",
    "steel": "STEEL",
    "fairy": "FAIRY",
}

ABILITY_MAP = {
    "synchronize": "SYNCHRONIZE",
    "trace": "TRACE",
    "magic-guard": "MAGIC_GUARD",
    "steadfast": "STEADFAST",
    "sharpness": "SHARPNESS",
    "defiant": "DEFIANT",
    "justified": "JUSTIFIED",
    "intimidate": "INTIMIDATE",
    "pressure": "PRESSURE",
    "inner-focus": "INNER_FOCUS",
    "limber": "LIMBER",
    "swarm": "SWARM",
    "shed-skin": "SHED_SKIN",
    "hyper-cutter": "HYPER_CUTTER",
    "sand-veil": "SAND_VEIL",
    "levitate": "LEVITATE",
    "sturdy": "STURDY",
    "rock-head": "ROCK_HEAD",
    "lightning-rod": "LIGHTNING_ROD",
    "rivalry": "RIVALRY",
    "cute-charm": "CUTE_CHARM",
    "run-away": "RUN_AWAY",
    "pickup": "PICKUP",
    "quick-feet": "QUICK_FEET",
    "guts": "GUTS",
    "hustle": "HUSTLE",
    "natural-cure": "NATURAL_CURE",
    "serene-grace": "SERENE_GRACE",
    "chlorophyll": "CHLOROPHYLL",
    "overgrow": "OVERGROW",
    "blaze": "BLAZE",
    "torrent": "TORRENT",
    "swiftswim": "SWIFT_SWIM",
    "swift-swim": "SWIFT_SWIM",
    "sand-rush": "SAND_RUSH",
    "mold-breaker": "MOLD_BREAKER",
    "technician": "TECHNICIAN",
    "prankster": "PRANKSTER",
    "competitive": "COMPETITIVE",
    "pixilate": "PIXILATE",
    "clear-body": "CLEAR_BODY",
    "light-metal": "LIGHT_METAL",
    "heavy-metal": "HEAVY_METAL",
    "magnet-pull": "MAGNET_PULL",
    "analytic": "ANALYTIC",
    "download": "DOWNLOAD",
    "battle-armor": "BATTLE_ARMOR",
    "keen-eye": "KEEN_EYE",
    "vital-spirit": "VITAL_SPIRIT",
    "anger-point": "ANGER_POINT",
    "unburden": "UNBURDEN",
    "frisk": "FRISK",
    "reckless": "RECKLESS",
    "multiscale": "MULTISCALE",
    "moxie": "MOXIE",
    "iron-fist": "IRON_FIST",
    "steadfast": "STEADFAST",
}

GROWTH_MAP = {
    "slow": "GROWTH_SLOW",
    "medium-slow": "GROWTH_MEDIUM_SLOW",
    "medium-fast": "GROWTH_MEDIUM_FAST",
    "fast": "GROWTH_FAST",
    "fluctuating": "GROWTH_MEDIUM_FAST",
    "erratic": "GROWTH_MEDIUM_FAST",
}

EGG_GROUP_MAP = {
    "monster": "EGG_MONSTER",
    "water1": "EGG_WATER_1",
    "bug": "EGG_BUG",
    "flying": "EGG_FLYING",
    "ground": "EGG_GROUND",
    "fairy": "EGG_FAIRY",
    "plant": "EGG_PLANT",
    "humanshape": "EGG_HUMANSHAPE",
    "water3": "EGG_WATER_3",
    "mineral": "EGG_MINERAL",
    "indeterminate": "EGG_INDETERMINATE",
    "water2": "EGG_WATER_2",
    "ditto": "EGG_DITTO",
    "dragon": "EGG_DRAGON",
    "no-eggs": "EGG_NONE",
}

GENDER_MAP = {
    0: "GENDER_F0",
    12.5: "GENDER_F12_5",
    25: "GENDER_F25",
    37.5: "GENDER_F37_5",
    50: "GENDER_F50",
    62.5: "GENDER_F62_5",
    75: "GENDER_F75",
    87.5: "GENDER_F87_5",
    100: "GENDER_F100",
    -1: "GENDER_UNKNOWN",
}

HATCH_MAP = {
    "slow": "HATCH_SLOW",
    "medium-slow": "HATCH_MEDIUM_SLOW",
    "medium-fast": "HATCH_MEDIUM_FAST",
    "fast": "HATCH_FAST",
}


def planned_species() -> list[str]:
    out: list[str] = []
    for line in REGIONAL_DEX.read_text().splitlines():
        line = line.strip()
        if line.upper().startswith("PLANNED "):
            fn = line.split(";", 1)[0].removeprefix("PLANNED").strip()
            out.append(fn)
    return out


def gfx_folder_name(placeholder: str) -> str:
    return placeholder


def label_name(filename: str) -> str:
    base = filename.removesuffix(".asm")
    if base.endswith("_plain"):
        base = base[: -len("_plain")]
    parts = base.split("_")
    return "".join(p.capitalize() for p in parts)


def const_name(filename: str) -> str:
    return filename.removesuffix(".asm").upper()


def display_name(filename: str) -> str:
    base = filename.removesuffix(".asm").replace("_", " ").title()
    specials = {
        "Porygon Z": "Porygon-Z",
        "Mime Jr ": "Mime Jr.",
        "Mr  Rime": "Mr.Rime",
        "Farfetch D": "Farfetch'd",
        "Ho Oh": "Ho-Oh",
        "Nidoran F": "Nidoran♀",
        "Nidoran M": "Nidoran♂",
    }
    return specials.get(base, base)


def padded_name(filename: str) -> str:
    name = display_name(filename)
    if len(name) > 10:
        name = name[:10]
    return name.ljust(10, "@")[:10]


def api_name(filename: str) -> str:
    base = filename.removesuffix(".asm")
    if base in API_OVERRIDES:
        return API_OVERRIDES[base]
    return base.replace("__", "-").replace("_", "-")


def api_get(url: str) -> dict:
    CACHE.mkdir(parents=True, exist_ok=True)
    key = re.sub(r"[^a-zA-Z0-9]", "_", url)
    cache = CACHE / f"{key}.json"
    if cache.exists():
        return json.loads(cache.read_text())
    req = urllib.request.Request(url, headers={"User-Agent": "pkmn-international-police/1.0"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.loads(resp.read().decode())
    cache.write_text(json.dumps(data))
    return data


def fetch_species(api: str) -> dict:
    return api_get(f"https://pokeapi.co/api/v2/pokemon/{api}")


def fetch_species_meta(api: str) -> dict:
    return api_get(f"https://pokeapi.co/api/v2/pokemon-species/{api}")


def map_ability(slug: str) -> str:
    return ABILITY_MAP.get(slug, "SYNCHRONIZE")


def ev_yield_line(stats: list[dict]) -> str:
    best = max(stats[1:], key=lambda s: s["base_stat"])
    stat = best["stat"]["name"]
    mapping = {
        "hp": "HP",
        "attack": "Atk",
        "defense": "Def",
        "special-attack": "SAt",
        "special-defense": "SDef",
        "speed": "Spe",
    }
    return f"\tev_yield 1 {mapping[stat]}"


def tmhm_placeholder(types: tuple[str, str]) -> str:
  # minimal learnset - tackle + stab type move
    moves = ["TOXIC", "HIDDEN_POWER", "PROTECT", "RETURN", "DOUBLE_TEAM", "SUBSTITUTE", "FACADE", "REST", "ATTRACT", "SLEEP_TALK", "SWAGGER"]
    if "PSYCHIC" in types:
        moves += ["PSYCHIC", "CALM_MIND", "SHADOW_BALL"]
    if "FIGHTING" in types:
        moves += ["BRICK_BREAK", "CLOSE_COMBAT", "BULK_UP"]
    if "STEEL" in types:
        moves += ["IRON_HEAD", "FLASH_CANNON"]
    if "DARK" in types:
        moves += ["CRUNCH", "DARK_PULSE"]
    if "FAIRY" in types:
        moves += ["DAZZZLINGLEAM", "DRAINING_KISS"]
    if "DRAGON" in types:
        moves += ["DRAGON_CLAW", "DRAGON_PULSE"]
    if "ELECTRIC" in types:
        moves += ["THUNDERBOLT", "THUNDER_WAVE"]
    if "FIRE" in types:
        moves += ["FLAMETHROWER", "FIRE_BLAST"]
    if "WATER" in types:
        moves += ["SURF", "ICE_BEAM"]
    if "GRASS" in types:
        moves += ["GIGA_DRAIN", "ENERGY_BALL"]
    if "GROUND" in types:
        moves += ["EARTHQUAKE", "DIG"]
    if "FLYING" in types:
        moves += ["AERIAL_ACE", "BRAVE_BIRD"]
    if "POISON" in types:
        moves += ["SLUDGE_BOMB", "POISON_JAB"]
    if "BUG" in types:
        moves += ["X_SCISSOR", "BUG_BUZZ"]
    if "GHOST" in types:
        moves += ["SHADOW_BALL", "SHADOW_CLAW"]
    if "ROCK" in types:
        moves += ["ROCK_SLIDE", "STONE_EDGE"]
    if "ICE" in types:
        moves += ["ICE_BEAM", "BLIZZARD"]
    uniq = []
    for m in moves:
        if m not in uniq:
            uniq.append(m)
    return "\ttmhm " + ", ".join(uniq)


def write_base_stats(filename: str, data: dict, meta: dict) -> None:
    const = const_name(filename)
    stats = {s["stat"]["name"]: s["base_stat"] for s in data["stats"]}
    total = sum(stats.values())
    types = tuple(TYPE_MAP[t["type"]["name"]] for t in sorted(data["types"], key=lambda x: x["slot"]))
    t1, t2 = types if len(types) == 2 else (types[0], types[0])
    abilities = [map_ability(a["ability"]["name"]) for a in data["abilities"][:3]]
    while len(abilities) < 3:
        abilities.append(abilities[-1])
    gender = GENDER_MAP.get(meta["gender_rate"], "GENDER_F50")
    if gender == "GENDER_UNKNOWN" and meta["gender_rate"] != -1:
        gender = "GENDER_F50"
    hatch = "HATCH_MEDIUM_FAST"
    growth = GROWTH_MAP.get(meta["growth_rate"]["name"], "GROWTH_MEDIUM_FAST")
    egg_groups = meta.get("egg_groups", [])
    if len(egg_groups) >= 2:
        eg1 = EGG_GROUP_MAP.get(egg_groups[0]["name"], "EGG_MONSTER")
        eg2 = EGG_GROUP_MAP.get(egg_groups[1]["name"], eg1)
    elif egg_groups:
        eg1 = eg2 = EGG_GROUP_MAP.get(egg_groups[0]["name"], "EGG_MONSTER")
    else:
        eg1 = eg2 = "EGG_MONSTER"
    text = f"""\tbst {total:3d}, {stats['hp']:3d}, {stats['attack']:3d}, {stats['defense']:3d}, {stats['speed']:3d}, {stats['special-attack']:3d}, {stats['special-defense']:3d}
\t;   bst   hp  atk  def  sat  sdf  spe

\tdb {t1}, {t2} ; type
\tdb 45 ; catch rate
\tdb {data['base_experience']:3d} ; base exp
\tdb NO_ITEM, NO_ITEM ; held items
\tdn {gender}, {hatch} ; gender ratio, step cycles to hatch

\tabilities_for {const}, {abilities[0]}, {abilities[1]}, {abilities[2]}
\tdb {growth} ; growth rate
\tdn {eg1}, {eg2} ; egg groups

{ev_yield_line(data['stats'])}

\t; tm/hm learnset (placeholder)
{tmhm_placeholder((t1, t2))}
\t; end
"""
    (BASE_STATS_DIR / filename).write_text(text)


def copy_gfx(filename: str, placeholder: str) -> None:
    src_name = gfx_folder_name(placeholder)
    src = GFX_DIR / src_name
    dst = GFX_DIR / filename.removesuffix(".asm")
    if dst.exists():
        return
    shutil.copytree(src, dst)
    # footprint + minis + icons
    fp_src = FOOTPRINT_DIR / f"{src_name.split('_')[0]}.png"
    if not fp_src.exists():
        fp_src = FOOTPRINT_DIR / f"{src_name}.png"
    fp_dst = FOOTPRINT_DIR / f"{filename.removesuffix('.asm')}.png"
    if fp_src.exists() and not fp_dst.exists():
        shutil.copy(fp_src, fp_dst)
    for suffix in ("", "_mask"):
        mini_src = MINI_DIR / f"{src_name.split('_')[0]}{suffix}.png"
        if not mini_src.exists():
            mini_src = MINI_DIR / f"{src_name}{suffix}.png"
        mini_dst = MINI_DIR / f"{filename.removesuffix('.asm')}{suffix}.png"
        if mini_src.exists() and not mini_dst.exists():
            shutil.copy(mini_src, mini_dst)
    icon_src = ICON_DIR / f"{src_name.split('_')[0]}.png"
    if not icon_src.exists():
        icon_src = ICON_DIR / f"{src_name}.png"
    icon_dst = ICON_DIR / f"{filename.removesuffix('.asm')}.png"
    if icon_src.exists() and not icon_dst.exists():
        shutil.copy(icon_src, icon_dst)


def insert_before_marker(content: str, marker: str, lines: list[str]) -> str:
    block = "\n".join(lines) + "\n"
    if marker not in content:
        raise RuntimeError(f"marker not found: {marker}")
    return content.replace(marker, block + marker, 1)


def insert_before_assert(content: str, marker: str, lines: list[str]) -> str:
    return insert_before_marker(content, marker, lines)


def patch_constants(species: list[str]) -> None:
    path = ROOT / "constants/pokemon_constants.asm"
    text = path.read_text()
    lines = [f"\tconst {const_name(fn)}" for fn in species]
    text = insert_before_marker(text, "DEF NUM_SPECIES EQU", lines)
    path.write_text(text)


def patch_include_list(path: Path, species: list[str], marker: str = "assert_table_length NUM_SPECIES") -> None:
    text = path.read_text()
    lines = [f'INCLUDE "data/pokemon/base_stats/{fn}"' for fn in species]
    text = insert_before_marker(text, marker, lines)
    path.write_text(text)


def patch_simple_table(path: Path, species: list[str], fmt: str, marker: str = "assert_table_length NUM_SPECIES") -> None:
    text = path.read_text()
    lines = [
        fmt.format(label=label_name(fn), const=const_name(fn), file=fn.removesuffix(".asm"))
        for fn in species
    ]
    text = insert_before_marker(text, marker, lines)
    path.write_text(text)


def patch_evos_attacks(species: list[str]) -> None:
    path = ROOT / "data/pokemon/evos_attacks.asm"
    text = path.read_text()
    chunks: list[str] = []
    for fn in species:
        label = label_name(fn)
        const = const_name(fn)
        lines = [f"\n\tevos_attacks {label}"]
        for evo in EVOLUTIONS.get(fn, []):
            lines.append(f"\tevo_data {evo[0]}, {evo[1]}, {evo[2]}")
        lines.append("\tlearnset 1, TACKLE")
        if "PSYCHIC" in (BASE_STATS_DIR / fn).read_text():
            lines.append("\tlearnset 1, CONFUSION")
        if const in ("PAWNIARD", "BISHARP", "KINGAMBIT"):
            lines.append("\tlearnset 1, METAL_CLAW")
        if const == "HAWLUCHA":
            lines.append("\tlearnset 1, LOW_KICK")
        chunks.append("\n".join(lines))
    insert = "\n".join(chunks) + "\n"
    needle = "\n\tevos_attacks MrMimeGalarian"
    if needle not in text:
        raise RuntimeError("evos_attacks insert point missing")
    text = text.replace(needle, insert + needle, 1)
    path.write_text(text)


def patch_dex_entries(species: list[str]) -> None:
    path = ROOT / "data/pokemon/dex_entries.asm"
    text = path.read_text()
    blocks: list[str] = []
    for fn in species:
        label = label_name(fn)
        name = display_name(fn)
        blocks.append(
            f"""
SECTION "{label}PokedexEntry", ROMX
{label}PokedexEntry::
\tdb "{name}@"
\ttext "Placeholder"
\tnext "dex entry."
\tnext "Graphics will"
\tpage "be updated"
\tnext "in a future"
\tnext "release.@"
"""
        )
    insert = "".join(blocks)
    needle = '\nSECTION "GyaradosRedPokedexEntry", ROMX'
    text = text.replace(needle, insert + needle, 1)
    path.write_text(text)


def patch_gfx_pokemon(species: list[str]) -> None:
    path = ROOT / "gfx/pokemon.asm"
    text = path.read_text()
    blocks: list[str] = []
    for fn in species:
        label = label_name(fn)
        folder = fn.removesuffix(".asm")
        blocks.append(
            f"""
SECTION "{label} Pics", ROMX
{label}Frontpic: INCBIN "gfx/pokemon/{folder}/front.animated.2bpp.lzp"
{label}Backpic:  INCBIN "gfx/pokemon/{folder}/back.2bpp.lzp"
{label}Frames:   INCLUDE "gfx/pokemon/{folder}/frames.asm"
"""
        )
    insert = "".join(blocks)
    needle = '\nSECTION "Madame Pics", ROMX'
    text = text.replace(needle, insert + needle, 1)
    path.write_text(text)


def patch_minis(species: list[str]) -> None:
    path = ROOT / "gfx/minis_icons.asm"
    text = path.read_text()
    blocks: list[str] = []
    for fn in species:
        label = label_name(fn)
        folder = fn.removesuffix(".asm")
        blocks.append(
            f"""
SECTION "{label} Mini Icon", ROMX
{label}Mini::     INCBIN "gfx/minis/{folder}.2bpp.lzp"
{label}MiniMask:: INCBIN "gfx/minis/{folder}_mask.1bpp.lzp"
{label}Icon::     INCBIN "gfx/icons/{folder}.2bpp.lzp"
"""
        )
    insert = "".join(blocks)
    needle = '\nSECTION "Madame Mini Icon", ROMX'
    text = text.replace(needle, insert + needle, 1)
    path.write_text(text)


def patch_bitmasks(species: list[str]) -> None:
    path = ROOT / "gfx/pokemon/bitmasks.asm"
    text = path.read_text()
    lines = [
        f"{label_name(fn)}Bitmasks:     INCLUDE \"gfx/pokemon/{fn.removesuffix('.asm')}/bitmask.asm\""
        for fn in species
    ]
    text = insert_before_marker(text, "EggBitmasks:", lines)
    path.write_text(text)


def patch_anims(species: list[str]) -> None:
    path = ROOT / "gfx/pokemon/anims.asm"
    text = path.read_text()
    lines = [
        f"{label_name(fn)}Animation:     INCLUDE \"gfx/pokemon/{fn.removesuffix('.asm')}/anim.asm\""
        for fn in species
    ]
    text = insert_before_marker(text, "EggAnimation:", lines)
    path.write_text(text)


def patch_extras(species: list[str]) -> None:
    path = ROOT / "gfx/pokemon/extras.asm"
    text = path.read_text()
    lines = [
        f"{label_name(fn)}AnimationExtra:     INCLUDE \"gfx/pokemon/{fn.removesuffix('.asm')}/anim_idle.asm\""
        for fn in species
    ]
    text = insert_before_marker(text, "EggAnimationExtra:", lines)
    path.write_text(text)


def patch_footprints(species: list[str]) -> None:
    path = ROOT / "gfx/pokemon/footprints.asm"
    text = path.read_text()
    lines = [
        f"{label_name(fn)}Footprint::     INCBIN \"gfx/footprints/{fn.removesuffix('.asm')}.1bpp.lzp\""
        for fn in species
    ]
    text = insert_before_marker(text, "EggFootprint::", lines)
    path.write_text(text)


def patch_regional_dex(species: list[str]) -> None:
    path = REGIONAL_DEX
    text = path.read_text()
    for fn in species:
        text = text.replace(f"PLANNED {fn}", fn)
    # update counts in header/footer
    in_rom = sum(1 for line in text.splitlines() if line.strip().endswith(".asm") and not line.strip().startswith("#") and "PLANNED" not in line.upper())
    text = re.sub(r"# Total: \d+ species", f"# Total: {in_rom} species", text)
    text = re.sub(r"# In ROM: \d+", f"# In ROM: {in_rom}", text)
    text = re.sub(r"# Planned: \d+", "# Planned: 0", text)
    path.write_text(text)


def patch_palettes(species: list[str]) -> None:
    path = ROOT / "data/pokemon/palettes.asm"
    text = path.read_text()
    lines: list[str] = []
    for fn in species:
        folder = fn.removesuffix(".asm")
        lines.append(f'INCLUDE "gfx/pokemon/{folder}/normal.pal"')
        lines.append(f'INCLUDE "gfx/pokemon/{folder}/shiny.pal"')
    text = insert_before_marker(text, "assert_table_length NUM_SPECIES + 1", lines)
    path.write_text(text)


def main() -> None:
    species = planned_species()
    if not species:
        print("No PLANNED species found.")
        return
    print(f"Adding {len(species)} species…")
    for fn in species:
        if (BASE_STATS_DIR / fn).exists():
            print(f"  skip existing {fn}")
            continue
        api = api_name(fn)
        print(f"  fetch {api}")
        data = fetch_species(api)
        meta = fetch_species_meta(api)
        write_base_stats(fn, data, meta)
        ph = PLACEHOLDER_GFX[fn]
        copy_gfx(fn, ph)

    existing = [fn for fn in species if (BASE_STATS_DIR / fn).exists()]
    if not existing:
        print("Nothing new to register.")
        return

    patch_constants(existing)
    patch_include_list(ROOT / "data/pokemon/base_stats.asm", existing)
    patch_simple_table(ROOT / "data/pokemon/pic_pointers.asm", existing, "\tpics {label}")
    patch_simple_table(ROOT / "data/pokemon/evos_attacks_pointers.asm", existing, "\tdw {label}EvosAttacks")
    path = ROOT / "data/pokemon/names.asm"
    text = path.read_text()
    name_lines = [f'\trawchar "{padded_name(fn)}"' for fn in existing]
    text = insert_before_marker(text, "assert_table_length NUM_SPECIES + 1", name_lines)
    path.write_text(text)
    patch_simple_table(ROOT / "data/pokemon/body_data.asm", existing, "\tbody_data   8,  200, BIPEDAL,      GRAY   ; {const}")
    patch_simple_table(ROOT / "data/pokemon/cries.asm", existing, "\tmon_cry CRY_ABRA,      $000,  $100 ; {const}")
    patch_simple_table(ROOT / "data/pokemon/dex_entry_pointers.asm", existing, "\tdba {label}PokedexEntry")
    patch_simple_table(ROOT / "data/pokemon/pic_sizes.asm", existing, 'INCLUDE "gfx/pokemon/{file}/front.dimensions"', marker="assert_list_length NUM_SPECIES")
    patch_palettes(existing)
    patch_simple_table(ROOT / "data/pokemon/valid_levels.asm", existing, "\tdb   5, 100 ; {const}")
    patch_simple_table(ROOT / "data/pokemon/evolution_moves.asm", existing, "\tdb NO_MOVE      ; {const}")
    path = ROOT / "data/pokemon/egg_move_pointers.asm"
    text = path.read_text()
    egg_lines = [f"\tdw {EGG_MOVE_SOURCE[fn]}EggSpeciesMoves            ; {const_name(fn)}" for fn in existing]
    text = insert_before_marker(text, "assert_table_length NUM_SPECIES", egg_lines)
    path.write_text(text)

    patch_simple_table(ROOT / "data/pokemon/overworld_icon_pals.asm", existing, "\ticonpal TAN_GRAY, TAN_BLUE ; {const}")
    patch_simple_table(ROOT / "data/pokemon/mini_icon_pointers.asm", existing, "\tmini_icon {label}")
    patch_simple_table(ROOT / "gfx/pokemon/anim_pointers.asm", existing, "\tdw {label}Animation")
    patch_simple_table(ROOT / "gfx/pokemon/extra_pointers.asm", existing, "\tdw {label}AnimationExtra")
    patch_simple_table(ROOT / "gfx/pokemon/bitmask_pointers.asm", existing, "\tdw {label}Bitmasks")
    patch_simple_table(ROOT / "data/pokemon/footprint_pointers.asm", existing, "\tfardw {label}Footprint")

    patch_evos_attacks(existing)
    patch_dex_entries(existing)
    patch_gfx_pokemon(existing)
    patch_minis(existing)
    patch_bitmasks(existing)
    patch_anims(existing)
    patch_extras(existing)
    patch_footprints(existing)
    patch_regional_dex(existing)
    print(f"Done — registered {len(existing)} species.")


if __name__ == "__main__":
    main()
