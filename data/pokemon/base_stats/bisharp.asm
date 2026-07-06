	bst 490,  65, 125, 100,  70,  60,  70
	;   bst   hp  atk  def  sat  sdf  spe

	db DARK, STEEL ; type
	db 45 ; catch rate
	db 172 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for BISHARP, DEFIANT, INNER_FOCUS, PRESSURE
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, IRON_HEAD, FLASH_CANNON, CRUNCH, DARK_PULSE, SACRED_SWORD
	; end
