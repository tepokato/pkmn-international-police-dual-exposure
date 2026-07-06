	bst 335,  55,  55,  55,  30,  85,  55
	;   bst   hp  atk  def  sat  sdf  spe

	db PSYCHIC, PSYCHIC ; type
	db 45 ; catch rate
	db  67 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for ELGYEM, SYNCHRONIZE, SYNCHRONIZE, ANALYTIC
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	ev_yield 1 SAt

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, PSYCHIC, CALM_MIND, SHADOW_BALL
	; end
