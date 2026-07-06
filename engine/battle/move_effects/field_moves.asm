BattleCommand_stealthrock:
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyHazards
	jr z, .got_hazards
	ld hl, wPlayerHazards
.got_hazards
	ld a, [hl]
	and HAZARDS_STEALTH_ROCK
	jr nz, FailSpikes
	ld a, HAZARDS_STEALTH_ROCK
	or [hl]
	ld [hl], a
	call AnimateCurrentMove
	ld hl, StealthRockText
	jmp StdBattleTextbox

BattleCommand_defog:
	call AnimateCurrentMove
	xor a
	ld [wPlayerHazards], a
	ld [wEnemyHazards], a
	ld [wPlayerScreens], a
	ld [wEnemyScreens], a
	ld hl, DefogText
	call StdBattleTextbox
	ld a, EVASION
	ld [wChangedStat], a
	jmp ForceLowerStat

BattleCommand_yawn:
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyYawnCount
	jr z, .got_count
	ld hl, wPlayerYawnCount
.got_count
	ld a, [hl]
	and a
	jr nz, .failed
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	jr nz, .failed
	ld b, 0
	call CanSleepTarget
	jr c, .ability_ok
	jr nz, .failed
.ability_ok
	ld a, 2
	ld [hl], a
	call AnimateCurrentMove
	ld hl, YawnText
	jmp StdBattleTextbox

.failed
	call AnimateFailedMove
	jmp PrintButItFailed

BattleCommand_tailwind:
	ldh a, [hBattleTurn]
	and a
	ld hl, wPlayerTailwindCount
	jr z, .got_count
	ld hl, wEnemyTailwindCount
.got_count
	ld a, [hl]
	and a
	jr nz, .failed
	ld a, 4
	ld [hl], a
	call AnimateCurrentMove
	ld hl, TailwindText
	jmp StdBattleTextbox

.failed
	call AnimateFailedMove
	jmp PrintButItFailed

BattleCommand_healblock:
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyHealBlockCount
	jr z, .got_count
	ld hl, wPlayerHealBlockCount
.got_count
	ld a, [hl]
	and a
	jr nz, .failed
	ld a, 5
	ld [hl], a
	call AnimateCurrentMove
	ld hl, HealBlockText
	jmp StdBattleTextbox

.failed
	call AnimateFailedMove
	jmp PrintButItFailed

CheckHealBlocked:
; Returns carry if the current side cannot heal.
	ldh a, [hBattleTurn]
	and a
	ld hl, wPlayerHealBlockCount
	jr z, .got_count
	ld hl, wEnemyHealBlockCount
.got_count
	ld a, [hl]
	and a
	ret z
	scf
	ret

HandleYawn:
	call SetFastestTurn
	call .do_it
	call SwitchTurn

.do_it
	call HasUserFainted
	ret z
	ldh a, [hBattleTurn]
	and a
	ld hl, wPlayerYawnCount
	jr z, .got_count
	ld hl, wEnemyYawnCount
.got_count
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP_MASK
	ret nz
	ld b, 0
	call CanSleepTarget
	jr c, .sleep_ok
	ret nz
	xor a
	ld [hl], a
	ret
.sleep_ok
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	ld a, 3
	ld [hl], a
	call UpdateUserInParty
	call UpdateBattleHuds
	ld hl, YawnSleepText
	jmp StdBattleTextbox

HandleTailwind:
	ld hl, wPlayerTailwindCount
	call .tick
	ld hl, wEnemyTailwindCount
	jmp .tick

.tick
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	ld hl, TailwindEndedText
	jmp StdBattleTextbox

HandleHealBlock:
	ld hl, wPlayerHealBlockCount
	call .tick
	ld hl, wEnemyHealBlockCount
.tick
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	ld hl, HealBlockEndedText
	jmp StdBattleTextbox

StealthRockDamage:
; Called from SpikesDamage with hl = hazards, b = ability.
	ld a, b
	cp MAGIC_GUARD
	ret z
	ld a, [hl]
	and HAZARDS_STEALTH_ROCK
	ret z

	push hl
	push de

	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	ld b, a
	ld a, ROCK
	ld [wPlayerMoveStruct + MOVE_TYPE], a
	ld [wEnemyMoveStruct + MOVE_TYPE], a

	ld hl, wBattleMonType1
	call GetUserMonAttr
	push hl
	call CheckTypeMatchup
	pop hl

	ld a, b
	ld [wPlayerMoveStruct + MOVE_TYPE], a
	ld [wEnemyMoveStruct + MOVE_TYPE], a

	ld a, [wTypeMatchup]
	and a
	jr z, .done

	call GetEighthMaxHP
	ld a, [wTypeMatchup]
	cp NOT_VERY_EFFECTIVE
	call z, HalveBC
	ld a, [wTypeMatchup]
	cp SUPER_EFFECTIVE
	jr c, .deal
	call z, DoubleBC
	ld a, [wTypeMatchup]
	cp $40
	call z, DoubleBC

.deal
	call SubtractHPFromUser
	call UpdateUserInParty
	ld hl, BattleText_UserHurtByStealthRock
	call StdBattleTextbox

.done
	pop de
	pop hl
	ret

ApplySacredSwordDefenseBoost:
; Ignores the target's Defense stat changes.
	ld a, 7
	ld b, a
	call DoStatChangeMod
	jmp MultiplyAndDivide
