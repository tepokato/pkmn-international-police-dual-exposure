# Pokémon International Police: Dual Exposure

A **Pokémon Crystal ROM hack** built on [Polished Crystal](https://github.com/Rangi42/polishedcrystal), itself based on [pret's Crystal disassembly](https://github.com/pret/pokecrystal).

This project trims and reshapes Polished Crystal into a focused Johto/Kanto adventure with a custom **239-species regional dex**, modernized moves, and tooling to keep learnsets aligned with Scarlet/Violet where practical.

> **Status:** Work in progress. There is no official release yet.

## What's different

- **239-species regional dex** — defined in [`data/pokemon/regional_dex.txt`](data/pokemon/regional_dex.txt). Several vanilla species are cut; Gen 3–9 lines are added (e.g. Ralts line, Shinx line, Riolu/Lucario, Pawniard line, Trapinch line, and more).
- **Move slot reworks** — repurposed legacy slots for modern moves, including Payback, Brick Break, Focus Energy, Discharge, Rock Tomb, Fake Out, and Feint.
- **Field move updates** — Rock Smash is replaced by Brick Break in the overworld; TM31 teaches Brick Break.
- **Trainer and encounter scope** — non-dex species removed or swapped in trainers and wild tables where applicable.
- **SV learnset sync** — optional Python tooling compares and applies Scarlet/Violet level-up data for regional dex species.

For the full upstream feature set (abilities, physical/special split, 60 fps overworld, storage redesign, etc.), see Polished Crystal's [FEATURES.md](FEATURES.md).

## Build

Requires [RGBDS](https://github.com/gbdev/RGBDS) (`rgbasm`, `rgblink`, `rgbfix`, `rgbgfx`).

```bash
make
```

Other useful targets:

```bash
make faithful   # Faithful-mode build variant
make clean
```

The output ROM is `polishedcrystal-3.2.3.gbc` (name comes from the upstream Makefile).

## Development tools

| Tool | Purpose |
|------|---------|
| [`tools/sv_sync.py`](tools/sv_sync.py) | Compare regional dex species to SV types and learnsets ([docs](tools/sv_sync/README.md)) |
| [`tools/sv_sync_apply_learnsets.py`](tools/sv_sync_apply_learnsets.py) | Apply SV level-up learnsets to `evos_attacks.asm` |
| [`tools/dex_move_audit.py`](tools/dex_move_audit.py) | Audit which ROM moves the regional dex actually learns ([docs](tools/dex_move_audit/README.md)) |
| [`tools/regional_dex_apply.py`](tools/regional_dex_apply.py) | Apply regional dex scope to ROM data |
| [`tools/regional_dex_scope.py`](tools/regional_dex_scope.py) | Inspect regional dex coverage |

Quick checks:

```bash
python3 tools/sv_sync.py report
python3 tools/dex_move_audit.py
```

## Repository layout

- `data/pokemon/regional_dex.txt` — canonical list of in-scope species
- `data/pokemon/evos_attacks.asm` — level-up learnsets and evolution data
- `data/moves/` — move definitions, TMs, animations
- `constants/` — move, species, and battle constants

## Upstream

This repo tracks Polished Crystal as **`upstream`**:

```bash
git fetch upstream
```

Base game documentation, FAQ, and screenshots still live in the upstream project:

- [Polished Crystal README](https://github.com/Rangi42/polishedcrystal)
- [FAQ](FAQ.md) · [FEATURES](FEATURES.md)

## License

Same as upstream Polished Crystal / pret disassembly (see repository history and upstream for details).
