	bst 281,  41,  50,  37,  66,  50,  37
	;   bst   hp  atk  def  sat  sdf  spe

	db DARK, DARK ; type
	db 45 ; catch rate
	db  56 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for PURRLOIN, LIMBER, UNBURDEN, PRANKSTER
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	ev_yield 1 Spe

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, CRUNCH, DARK_PULSE
	; end
