	bst 285,  40,  70,  40,  60,  35,  40
	;   bst   hp  atk  def  sat  sdf  spe

	db FIGHTING, FIGHTING ; type
	db 45 ; catch rate
	db  57 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for RIOLU, STEADFAST, INNER_FOCUS, PRANKSTER
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, BRICK_BREAK, CLOSE_COMBAT, BULK_UP
	; end
