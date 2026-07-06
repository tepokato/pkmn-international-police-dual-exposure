	bst 465,  65, 130,  60,  75,  75,  60
	;   bst   hp  atk  def  sat  sdf  spe

	db DARK, DARK ; type
	db 45 ; catch rate
	db 163 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for ABSOL, PRESSURE, SYNCHRONIZE, JUSTIFIED
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, CRUNCH, DARK_PULSE
	; end
