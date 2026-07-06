	bst 330,  40,  50,  90,  65,  30,  55
	;   bst   hp  atk  def  sat  sdf  spe

	db POISON, BUG ; type
	db 45 ; catch rate
	db  66 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for SKORUPI, BATTLE_ARMOR, SYNCHRONIZE, KEEN_EYE
	db GROWTH_SLOW ; growth rate
	dn EGG_BUG, EGG_WATER_3 ; egg groups

	ev_yield 1 Def

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, SLUDGE_BOMB, POISON_JAB, X_SCISSOR, BUG_BUZZ
	; end
