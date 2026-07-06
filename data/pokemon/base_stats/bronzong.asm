	bst 500,  67,  89, 116,  33,  79, 116
	;   bst   hp  atk  def  sat  sdf  spe

	db STEEL, PSYCHIC ; type
	db 45 ; catch rate
	db 175 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_UNKNOWN, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for BRONZONG, LEVITATE, SYNCHRONIZE, HEAVY_METAL
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	ev_yield 1 Def

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, PSYCHIC, CALM_MIND, SHADOW_BALL, IRON_HEAD, FLASH_CANNON, STEALTH_ROCK
	; end
