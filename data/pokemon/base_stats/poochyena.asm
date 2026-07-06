	bst 220,  35,  55,  35,  35,  30,  30
	;   bst   hp  atk  def  sat  sdf  spe

	db DARK, DARK ; type
	db 45 ; catch rate
	db  56 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for POOCHYENA, RUN_AWAY, QUICK_FEET, SYNCHRONIZE
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, CRUNCH, DARK_PULSE
	; end
