BattleCommand_taunt:
	ld b, TAUNT
	jr DoTauntTorment

BattleCommand_torment:
	ld b, TORMENT
DoTauntTorment:
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyTauntCount
	ld de, wEnemyTormentCount
	jr z, .player_is_target
	ld hl, wPlayerTauntCount
	ld de, wPlayerTormentCount
.player_is_target
	ld a, b
	cp TAUNT
	jr nz, .torment
	ld a, [hl]
	and a
	jr nz, .failed
	jr .apply

.torment
	ld a, [de]
	and a
	jr nz, .failed

.apply
	call GetOpponentIgnorableAbility
	cp BUSHIDO
	jr nz, .not_immune
	farcall BeginAbility
	farcall ShowEnemyAbilityActivation
	ld hl, DoesntAffectText
	call StdBattleTextbox
	farjp EndAbility

.not_immune
	farcall ShowPotentialAbilityActivation
	ld a, b
	cp TAUNT
	jr nz, .apply_torment
	ld a, 3
	ld [hl], a
	ld hl, GotTauntedText
	jr .finish

.apply_torment
	ld a, 1
	ld [de], a
	ldh a, [hBattleTurn]
	and a
	ld hl, wPlayerTormentLastMove
	jr z, .got_torment_last
	ld hl, wEnemyTormentLastMove
.got_torment_last
	xor a
	ld [hl], a
	ld hl, GotTormentedText

.finish
	call AnimateCurrentMove
	call StdBattleTextbox
	ldh a, [hBattleTurn]
	and a
	jr z, .mental_done
	ld a, b
	cp TAUNT
	ld a, MENTAL_F_TAUNTED_F
	jr z, .register_mental
	ld a, MENTAL_F_TORMENTED_F
.register_mental
	call RegisterPlayerMentalEffect
.mental_done
	ret

.failed
	call AnimateFailedMove
	ld hl, ButItFailedText
	jmp StdBattleTextbox

UpdateTormentLastMove:
; Records the committed move for Torment on the next turn.
	ldh a, [hBattleTurn]
	and a
	ld de, wPlayerTormentCount
	ld hl, wPlayerTormentLastMove
	jr z, .ok
	ld de, wEnemyTormentCount
	ld hl, wEnemyTormentLastMove
.ok
	ld a, [de]
	and a
	ret z
	ldh a, [hBattleTurn]
	and a
	ld a, [wCurPlayerMove]
	jr z, .store
	ld a, [wCurEnemyMove]
.store
	ld [hl], a
	ret
