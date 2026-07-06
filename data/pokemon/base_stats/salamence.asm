	bst 600,  95, 135,  80, 100, 110,  80
	;   bst   hp  atk  def  sat  sdf  spe

	db DRAGON, FLYING ; type
	db 45 ; catch rate
	db 270 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for SALAMENCE, INTIMIDATE, MOXIE, MOXIE
	db GROWTH_SLOW ; growth rate
	dn EGG_DRAGON, EGG_DRAGON ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, DRAGON_CLAW, DRAGON_PULSE, AERIAL_ACE, BRAVE_BIRD
	; end
