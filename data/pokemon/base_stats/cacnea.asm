	bst 335,  50,  85,  40,  35,  85,  40
	;   bst   hp  atk  def  sat  sdf  spe

	db GRASS, GRASS ; type
	db 45 ; catch rate
	db  67 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for CACNEA, SAND_VEIL, SYNCHRONIZE, SYNCHRONIZE
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_PLANT, EGG_HUMANSHAPE ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, GIGA_DRAIN, ENERGY_BALL
	; end
