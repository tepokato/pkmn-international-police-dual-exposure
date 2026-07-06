	bst 523,  80, 120,  79,  70,  95,  79
	;   bst   hp  atk  def  sat  sdf  spe

	db ELECTRIC, ELECTRIC ; type
	db 45 ; catch rate
	db 235 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for LUXRAY, RIVALRY, INTIMIDATE, GUTS
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, THUNDERBOLT, THUNDER_WAVE
	; end
