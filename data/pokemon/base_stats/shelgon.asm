	bst 420,  65,  95, 100,  50,  60,  50
	;   bst   hp  atk  def  sat  sdf  spe

	db DRAGON, DRAGON ; type
	db 45 ; catch rate
	db 147 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for SHELGON, ROCK_HEAD, SYNCHRONIZE, SYNCHRONIZE
	db GROWTH_SLOW ; growth rate
	dn EGG_DRAGON, EGG_DRAGON ; egg groups

	ev_yield 1 Def

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, DRAGON_CLAW, DRAGON_PULSE
	; end
