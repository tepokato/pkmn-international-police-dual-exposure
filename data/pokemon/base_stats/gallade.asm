	bst 518,  68, 125,  65,  80,  65, 115
	;   bst   hp  atk  def  sat  sdf  spe

	db PSYCHIC, FIGHTING ; type
	db 45 ; catch rate
	db 233 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F0, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for GALLADE, STEADFAST, SHARPNESS, JUSTIFIED
	db GROWTH_SLOW ; growth rate
	dn EGG_HUMANSHAPE, EGG_INDETERMINATE ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, PSYCHIC, CALM_MIND, SHADOW_BALL, BRICK_BREAK, CLOSE_COMBAT, BULK_UP, SACRED_SWORD
	; end
