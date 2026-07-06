	bst 329,  63,  63,  47,  74,  41,  41
	;   bst   hp  atk  def  sat  sdf  spe

	db POISON, DARK ; type
	db 45 ; catch rate
	db  66 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for STUNKY, SYNCHRONIZE, SYNCHRONIZE, KEEN_EYE
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	ev_yield 1 Spe

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, CRUNCH, DARK_PULSE, SLUDGE_BOMB, POISON_JAB
	; end
