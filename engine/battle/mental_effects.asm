; Mental effect tracking for Farfetch'd → Madame evolution, and Bushidō immunity helpers.

CheckBushidoImmune:
; Returns z if the opponent is immune due to Bushidō.
	call GetOpponentIgnorableAbility
	cp BUSHIDO
	ret

ShowBushidoImmune:
	call CheckBushidoImmune
	ret nz
	farcall BeginAbility
	farcall ShowEnemyAbilityActivation
	ld hl, DoesntAffectText
	call StdBattleTextbox
	farjp EndAbility

BattleCommand_checkbushidoimmune:
	call CheckBushidoImmune
	ret nz
	call AnimateFailedMove
	call ShowBushidoImmune
	jp EndMoveEffect

RegisterPlayerMentalEffect:
; Registers a mental effect flag on the player's active Pokémon.
; a = flag bit (1 << MENTAL_F_*)
	push bc
	ld b, a
	ld a, [wCurBattleMon]
	ld c, a
	ld hl, wMentalEffectFlags
	add hl, bc
	ld a, b
	or [hl]
	ld [hl], a
	call CheckMentalEvolutionReady
	pop bc
	ret

CheckMentalEvolutionReady:
; Sets wEvolvableFlags if the active player mon has 2+ mental effects.
	push bc
	ld a, [wCurBattleMon]
	ld c, a
	ld hl, wMentalEffectFlags
	add hl, bc
	ld a, [hl]
	ld b, 0
	ld c, a
.count_loop
	ld a, c
	or a
	jr z, .count_done
	inc b
	dec a
	and c
	ld c, a
	jr .count_loop
.count_done
	ld a, b
	cp 2
	jr c, .done
	ld hl, wEvolvableFlags
	ld a, [wCurBattleMon]
	ld c, a
	ld b, SET_FLAG
	farcall SmallFlagAction
.done
	pop bc
	ret

CountMentalEffectFlags:
; a = flag byte. Returns a = popcount.
	ld b, 0
	ld c, a
.count_loop
	ld a, c
	or a
	jr z, .count_done
	inc b
	dec a
	and c
	ld c, a
	jr .count_loop
.count_done
	ld a, b
	ret
