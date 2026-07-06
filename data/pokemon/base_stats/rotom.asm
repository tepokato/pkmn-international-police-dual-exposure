	bst 440,  50,  50,  77,  91,  95,  77
	;   bst   hp  atk  def  sat  sdf  spe

	db ELECTRIC, GHOST ; type
	db 45 ; catch rate
	db 154 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_UNKNOWN, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for ROTOM, LEVITATE, LEVITATE, LEVITATE
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_INDETERMINATE, EGG_INDETERMINATE ; egg groups

	ev_yield 1 SAt

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, THUNDERBOLT, THUNDER_WAVE, SHADOW_BALL, SHADOW_CLAW
	; end
