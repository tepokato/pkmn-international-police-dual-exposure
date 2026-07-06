	bst 300,  57,  24,  86,  23,  24,  86
	;   bst   hp  atk  def  sat  sdf  spe

	db STEEL, PSYCHIC ; type
	db 45 ; catch rate
	db  60 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_UNKNOWN, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for BRONZOR, LEVITATE, SYNCHRONIZE, HEAVY_METAL
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	ev_yield 1 Def

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, PSYCHIC, CALM_MIND, SHADOW_BALL, IRON_HEAD, FLASH_CANNON, STEALTH_ROCK
	; end
