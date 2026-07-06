	bst 520,  60, 100, 115,  90,  70,  85
	;   bst   hp  atk  def  sat  sdf  spe

	db STEEL, STEEL ; type
	db 45 ; catch rate
	db 234 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_UNKNOWN, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for KLINKLANG, SYNCHRONIZE, SYNCHRONIZE, CLEAR_BODY
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	ev_yield 1 Def

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, IRON_HEAD, FLASH_CANNON
	; end
