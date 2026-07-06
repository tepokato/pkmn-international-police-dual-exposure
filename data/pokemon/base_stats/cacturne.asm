	bst 475,  70, 115,  60,  55, 115,  60
	;   bst   hp  atk  def  sat  sdf  spe

	db GRASS, DARK ; type
	db 45 ; catch rate
	db 166 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for CACTURNE, SAND_VEIL, SYNCHRONIZE, SYNCHRONIZE
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_PLANT, EGG_HUMANSHAPE ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, CRUNCH, DARK_PULSE, GIGA_DRAIN, ENERGY_BALL
	; end
