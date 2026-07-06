	bst 278,  38,  35,  35,  50,  65,  55
	;   bst   hp  atk  def  sat  sdf  spe

	db PSYCHIC, FAIRY ; type
	db 45 ; catch rate
	db  97 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for KIRLIA, SYNCHRONIZE, TRACE, SYNCHRONIZE
	db GROWTH_SLOW ; growth rate
	dn EGG_HUMANSHAPE, EGG_INDETERMINATE ; egg groups

	ev_yield 1 SAt

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, PSYCHIC, CALM_MIND, SHADOW_BALL, DAZZZLINGLEAM, DRAINING_KISS
	; end
