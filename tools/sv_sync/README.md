# Scarlet/Violet sync tooling

Compares this ROM hack against **Pokémon Scarlet/Violet** (base game) via [PokeAPI](https://pokeapi.co/).

By default, only species listed in [`data/pokemon/regional_dex.txt`](../../data/pokemon/regional_dex.txt) are compared. Use `--all` to scan the full ROM.

## Commands

```bash
# Full report (types + level-up learnset gaps) — regional dex only
python3 tools/sv_sync.py report

# Compare every species in the ROM (ignore regional dex)
python3 tools/sv_sync.py report --all

# Type summary only
python3 tools/sv_sync.py types

# Patch type lines in data/pokemon/base_stats/*.asm (mismatches + order)
python3 tools/sv_sync.py apply-types

# Replace regional-dex level-up learnsets with SV (mapped ROM moves)
python3 tools/sv_sync_apply_learnsets.py
```

Outputs:

- `tools/sv_sync/report.md` — human-readable summary
- `tools/sv_sync/gaps.json` — machine-readable diffs
- `tools/sv_sync/cache/` — cached API responses (safe to delete)

## Defaults

| Setting | Value |
|---------|--------|
| Scope | `data/pokemon/regional_dex.txt` (246 species; 190 in ROM) |
| Version group | `scarlet-violet` |
| Learnsets | Level-up only |
| Skipped species | `madame`, `mewtwo_armored`, `egg` |

## Workflow

1. Run `report` and read `report.md`.
2. **Types** — usually already SV-correct (Gen VI+). Fix any real mismatches or order issues; `apply-types` can patch automatically.
3. **Learnsets** — run `python3 tools/sv_sync_apply_learnsets.py` to batch-replace regional dex level-up learnsets with SV data (mapped ROM moves only). Re-run `report` to see remaining gaps from moves not implemented in this ROM.
4. Unmapped SV moves in `gaps.json` still need ROM slots or intentional substitutes.

## Notes

- Single-type Pokémon are stored as `TYPE, TYPE` in Gen II style; the tool normalizes these against SV’s single-type API entries.
- Dual-type **order** is compared (primary/secondary); Sneasel-Hisuui/Sneasler use Fighting/Poison in SV.
- TM/tutor/egg learnsets are not compared yet.
