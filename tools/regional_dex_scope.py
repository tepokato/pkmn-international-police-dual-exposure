#!/usr/bin/env python3
"""Shared regional dex helpers."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGIONAL_DEX = ROOT / "data/pokemon/regional_dex.txt"
BASE_STATS_INDEX = ROOT / "data/pokemon/base_stats.asm"
POKEMON_CONSTANTS = ROOT / "constants/pokemon_constants.asm"


def load_regional_files() -> set[str]:
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


def file_to_const(filename: str) -> str:
    return filename.removesuffix(".asm").upper()


def file_to_label(filename: str) -> str:
    base = filename.removesuffix(".asm")
    return "".join(p.capitalize() for p in base.split("_"))


def load_rom_species_files() -> list[str]:
    out: list[str] = []
    for line in BASE_STATS_INDEX.read_text().splitlines():
        if "assert_table_length NUM_SPECIES" in line:
            break
        m = re.search(r'INCLUDE "data/pokemon/base_stats/([^"]+)"', line)
        if m:
            out.append(m.group(1))
    return out


def load_const_to_file() -> dict[str, str]:
    """Species constant -> primary base_stats filename (first in ROM table)."""
    mapping: dict[str, str] = {}
    for fn in load_rom_species_files():
        const = file_to_const(fn)
        if const not in mapping:
            mapping[const] = fn
    return mapping


def load_regional_constants() -> set[str]:
    return {file_to_const(f) for f in load_regional_files()}


def parse_all_species_constants() -> set[str]:
    consts: set[str] = set()
    for line in POKEMON_CONSTANTS.read_text().splitlines():
        m = re.match(r"\s*const\s+(\w+)\s*;", line)
        if m and m.group(1) not in ("EGG",):
            consts.add(m.group(1))
        if "DEF NUM_SPECIES" in line:
            break
    return consts
