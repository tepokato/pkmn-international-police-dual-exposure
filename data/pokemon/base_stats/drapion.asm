	bst 500,  70,  90, 110,  95,  60,  75
	;   bst   hp  atk  def  sat  sdf  spe

	db POISON, DARK ; type
	db 45 ; catch rate
	db 175 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for DRAPION, BATTLE_ARMOR, SYNCHRONIZE, KEEN_EYE
	db GROWTH_SLOW ; growth rate
	dn EGG_BUG, EGG_WATER_3 ; egg groups

	ev_yield 1 Def

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, CRUNCH, DARK_PULSE, SLUDGE_BOMB, POISON_JAB
	; end
