	bst 525,  70, 110,  70,  90, 115,  70
	;   bst   hp  atk  def  sat  sdf  spe

	db FIGHTING, STEEL ; type
	db 45 ; catch rate
	db 184 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for LUCARIO, STEADFAST, INNER_FOCUS, JUSTIFIED
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_HUMANSHAPE ; egg groups

	ev_yield 1 SAt

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, BRICK_BREAK, CLOSE_COMBAT, BULK_UP, IRON_HEAD, FLASH_CANNON, SACRED_SWORD
	; end
