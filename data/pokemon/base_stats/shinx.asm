	bst 263,  45,  65,  34,  45,  40,  34
	;   bst   hp  atk  def  sat  sdf  spe

	db ELECTRIC, ELECTRIC ; type
	db 45 ; catch rate
	db  53 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F50, HATCH_MEDIUM_FAST ; gender ratio, step cycles to hatch

	abilities_for SHINX, RIVALRY, INTIMIDATE, GUTS
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	ev_yield 1 Atk

	; tm/hm learnset (placeholder)
	tmhm TOXIC, HIDDEN_POWER, PROTECT, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, SLEEP_TALK, SWAGGER, THUNDERBOLT, THUNDER_WAVE
	; end
