	bst 240,  38,  30,  41,  60,  30,  41
	;   bst   hp  atk  def  sat  sdf  spe

	db NORMAL, NORMAL ; type
	db 45 ; catch rate
	db  56 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for ZIGZAGOON, PICKUP, SYNCHRONIZE, QUICK_FEET
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	ev_yield 1 Spe

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER
	; end
