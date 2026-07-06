	bst 300,  40,  40,  55,  55,  40,  70
	;   bst   hp  atk  def  sat  sdf  spe

	db GROUND, PSYCHIC ; type
	db 45 ; catch rate
	db  60 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_UNKNOWN, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for BALTOY, LEVITATE, LEVITATE, LEVITATE
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	ev_yield 1 SDef

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, PSYCHIC, CALM_MIND, SHADOW_BALL, EARTHQUAKE, DIG
	; end
