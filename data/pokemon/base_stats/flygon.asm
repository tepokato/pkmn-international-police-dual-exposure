	bst 520,  80, 100,  80, 100,  80,  80
	;   bst   hp  atk  def  sat  sdf  spe

	db GROUND, DRAGON ; type
	db 45 ; catch rate
	db 234 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for FLYGON, LEVITATE, LEVITATE, LEVITATE
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_BUG, EGG_DRAGON ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, DRAGON_CLAW, DRAGON_PULSE, EARTHQUAKE, DIG
	; end
