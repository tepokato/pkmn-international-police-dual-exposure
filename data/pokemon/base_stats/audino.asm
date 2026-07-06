	bst 445, 103,  60,  86,  50,  60,  86
	;   bst   hp  atk  def  sat  sdf  spe

	db NORMAL, NORMAL ; type
	db 45 ; catch rate
	db 390 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for AUDINO, SYNCHRONIZE, SYNCHRONIZE, SYNCHRONIZE
	db GROWTH_FAST ; growth rate
	dn EGG_FAIRY, EGG_FAIRY ; egg groups

	ev_yield 1 Def

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER
	; end
