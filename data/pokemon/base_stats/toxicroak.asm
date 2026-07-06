	bst 490,  83, 106,  65,  85,  86,  65
	;   bst   hp  atk  def  sat  sdf  spe

	db POISON, FIGHTING ; type
	db 45 ; catch rate
	db 172 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for TOXICROAK, SYNCHRONIZE, SYNCHRONIZE, SYNCHRONIZE
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, BRICK_BREAK, CLOSE_COMBAT, BULK_UP, SLUDGE_BOMB, POISON_JAB
	; end
