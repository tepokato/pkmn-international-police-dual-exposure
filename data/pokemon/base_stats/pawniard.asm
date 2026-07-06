	bst 340,  45,  85,  70,  60,  40,  40
	;   bst   hp  atk  def  sat  sdf  spe

	db DARK, STEEL ; type
	db 45 ; catch rate
	db  68 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for PAWNIARD, DEFIANT, INNER_FOCUS, PRESSURE
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, IRON_HEAD, FLASH_CANNON, CRUNCH, DARK_PULSE, SACRED_SWORD
	; end
