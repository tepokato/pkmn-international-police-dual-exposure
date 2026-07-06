	bst 500,  78,  92,  75, 118,  74,  63
	;   bst   hp  atk  def  sat  sdf  spe

	db FIGHTING, FLYING ; type
	db 45 ; catch rate
	db 175 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for HAWLUCHA, LIMBER, UNBURDEN, MOLD_BREAKER
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_FLYING, EGG_HUMANSHAPE ; egg groups

	ev_yield 1 Spe

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, BRICK_BREAK, CLOSE_COMBAT, BULK_UP, AERIAL_ACE, BRAVE_BIRD
	; end
