	bst 330,  50,  70, 100,  30,  40,  40
	;   bst   hp  atk  def  sat  sdf  spe

	db STEEL, ROCK ; type
	db 45 ; catch rate
	db  66 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for ARON, STURDY, ROCK_HEAD, HEAVY_METAL
	db GROWTH_SLOW ; growth rate
	dn EGG_MONSTER, EGG_MONSTER ; egg groups

	ev_yield 1 Def

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, IRON_HEAD, FLASH_CANNON, ROCK_SLIDE, STONE_EDGE
	; end
