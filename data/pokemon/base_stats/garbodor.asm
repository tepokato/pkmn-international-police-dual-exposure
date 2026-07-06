	bst 474,  80,  95,  82,  75,  60,  82
	;   bst   hp  atk  def  sat  sdf  spe

	db POISON, POISON ; type
	db 45 ; catch rate
	db 166 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for GARBODOR, SYNCHRONIZE, SYNCHRONIZE, SYNCHRONIZE
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, SLUDGE_BOMB, POISON_JAB
	; end
