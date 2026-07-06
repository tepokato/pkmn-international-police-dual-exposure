# Regional dex move audit

Regional dex: **239** species | ROM dex table: **238** in dex / **110** not in dex

## Summary

| Metric | Count |
|--------|------:|
| Total attack moves in ROM | 255 |
| Moves used by regional dex (level/TM/egg/evo) | 257 |
| Moves **not** learned by any regional dex species | **1** |
| Of those, only non-dex ROM species learn | 1 |
| Moves not on any species learnset path | 0 |
| Likely safe to remove / repurpose | **0** |
| Keep (hardcoded in battle/scripts) | 1 |
| TM/tutor moves no dex species learns | 3 |

## Moves not learned by any regional dex species

Primary trim list for your 246-species dex.

- `SPORE` *(non-dex exclusive)*

## Likely removable (no dex learnset + no script refs)

_None._

## Keep despite no dex learnsets (hardcoded references)

- `SPORE` — `data/battle_tower/parties.asm`, `data/moves/powder_moves.asm`, `data/trainers/parties.asm`

## TM / tutor moves no regional species learns

These could be removed from shops/tutors if you trim TM inventory to dex-only.

`ROCK_SMASH`, `TAUNT`, `TORMENT`

## Notes

- Trainers usually inherit moves from level-up learnsets at battle time; this audit is species-centric.
- Variant forms (Alolan, etc.) count as non-dex unless listed in `regional_dex.txt`.
- `ALWAYS_KEEP` includes Struggle, Transform, tutor staples, etc.
- Full detail: `tools/dex_move_audit/gaps.json`

