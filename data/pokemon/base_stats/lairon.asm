	bst 430,  60,  90, 140,  40,  50,  50
	;   bst   hp  atk  def  sat  sdf  spe

	db STEEL, ROCK ; type
	db 45 ; catch rate
	db 151 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for LAIRON, STURDY, ROCK_HEAD, HEAVY_METAL
	db GROWTH_SLOW ; growth rate
	dn EGG_MONSTER, EGG_MONSTER ; egg groups

	ev_yield 1 Def

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, IRON_HEAD, FLASH_CANNON, ROCK_SLIDE, STONE_EDGE
	; end
