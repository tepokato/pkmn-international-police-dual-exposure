# Regional dex move audit

```bash
python3 tools/dex_move_audit.py
```

Compares **attack moves** (`NUM_ATTACKS`) against what your 246-species regional dex can learn via:

- Level-up (`evos_attacks.asm`)
- TM/tutor (`base_stats` `tmhm` lines)
- Egg moves
- Evolution moves

Outputs:

- `report.md` — human summary
- `gaps.json` — machine-readable lists

Re-run after learnset or dex changes.
