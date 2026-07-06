	bst 329,  50,  50,  62,  65,  40,  62
	;   bst   hp  atk  def  sat  sdf  spe

	db POISON, POISON ; type
	db 45 ; catch rate
	db  66 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for TRUBBISH, SYNCHRONIZE, SYNCHRONIZE, SYNCHRONIZE
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	ev_yield 1 Spe

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, SLUDGE_BOMB, POISON_JAB
	; end
