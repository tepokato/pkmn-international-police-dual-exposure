DEF EVOS_ATTACKS_STATE EQU -1
DEF EVOS_ATTACKS_LAST_LEVEL EQU -1
DEF EVOS_ATTACKS_CURRENT_MON EQUS ""
DEF EVOS_ATTACKS_FIRST EQU 1

MACRO evo_data
	if EVOS_ATTACKS_STATE == 0
		if !EVOS_ATTACKS_FIRST
			db -1 ; end of previous mon's moves
		endc
		REDEF EVOS_ATTACKS_FIRST EQU 0
		{EVOS_ATTACKS_CURRENT_MON}EvosAttacks:
	endc
	assert EVOS_ATTACKS_STATE != 2, "{EVOS_ATTACKS_CURRENT_MON} has evo_data after its learnset!"
	REDEF EVOS_ATTACKS_STATE EQU 1
	db \1 ; evolution type
	if \1 == EVOLVE_PARTY
		dp \2, PLAIN_FORM ; parameter
	else
		db \2 ; parameter
	endc
	if \1 == EVOLVE_STAT || \1 == EVOLVE_HOLDING
		db \3 ; ATK_*_DEF | time of day
		shift
	endc
	if _NARG > 3
		dp \3, \4
	else
		dp \3, PLAIN_FORM
	endc
ENDM

MACRO evos_attacks
	REDEF EVOS_ATTACKS_CURRENT_MON EQUS "\1"
	assert EVOS_ATTACKS_STATE != 0, "Empty learnset preceding {EVOS_ATTACKS_CURRENT_MON}!"
	REDEF EVOS_ATTACKS_STATE EQU 0
	REDEF EVOS_ATTACKS_LAST_LEVEL EQU -1
ENDM

; For split banks, adds a terminator and resets tracking
MACRO end_evos_attacks
	assert EVOS_ATTACKS_STATE != 0, "Empty learnset for {EVOS_ATTACKS_CURRENT_MON}!"
	db -1
	REDEF EVOS_ATTACKS_STATE EQU -1
	REDEF EVOS_ATTACKS_FIRST EQU 1
ENDM

MACRO learnset
	REDEF EVOS_ATTACKS_FIRST EQU 0
	if \1 < EVOS_ATTACKS_LAST_LEVEL
		warn "{EVOS_ATTACKS_CURRENT_MON} learns \2 at a lower level than previous move!"
	endc
	if EVOS_ATTACKS_LAST_LEVEL == -1 && \1 != 1
		warn "{EVOS_ATTACKS_CURRENT_MON} learns its first move at level \1 instead of level 1!"
	endc
	if \1 < 1 || \1 > 100
		warn "{EVOS_ATTACKS_CURRENT_MON} learns a move at level \1, which should be impossible!"
	endc
	REDEF EVOS_ATTACKS_LAST_LEVEL EQU \1
	if EVOS_ATTACKS_STATE != 2
		if EVOS_ATTACKS_STATE == 0
			{EVOS_ATTACKS_CURRENT_MON}EvosAttacks:
		endc
		db -1 ; end of evolutions and, if there were no evos, previous mon's moves
	endc
	REDEF EVOS_ATTACKS_STATE EQU 2
	db \1 ; level
	db \2 ; move
ENDM


SECTION "Evolutions and Attacks", ROMX

INCLUDE "data/pokemon/evolution_moves.asm"

INCLUDE "data/pokemon/evos_attacks_pointers.asm"

EvosAttacks::

	evos_attacks Bulbasaur
	evo_data EVOLVE_LEVEL, 16, IVYSAUR
	learnset 1, TACKLE
	learnset 3, GROWL
	learnset 7, LEECH_SEED
	learnset 9, VINE_WHIP
	learnset 13, POISONPOWDER
	learnset 13, SLEEP_POWDER
	learnset 15, MUD_SLAP ; Take Down → GSC TM move
	learnset 19, RAZOR_LEAF
	learnset 21, TAKE_DOWN ; Sweet Scent → Take Down
	learnset 25, GROWTH
	learnset 27, DOUBLE_EDGE
	learnset 31, ANCIENTPOWER ; Worry Seed → event move
	learnset 33, HEALINGLIGHT ; Synthesis → similar move
	learnset 37, SEED_BOMB
	learnset 43, SLUDGE_BOMB ; TM move

	evos_attacks Ivysaur
	evo_data EVOLVE_LEVEL, 32, VENUSAUR
	learnset 1, TACKLE
	learnset 3, GROWL
	learnset 7, LEECH_SEED
	learnset 9, VINE_WHIP
	learnset 13, POISONPOWDER
	learnset 13, SLEEP_POWDER
	learnset 15, MUD_SLAP ; Take Down → GSC TM move
	learnset 20, RAZOR_LEAF
	learnset 23, TAKE_DOWN ; Sweet Scent → Take Down
	learnset 28, GROWTH
	learnset 31, DOUBLE_EDGE
	learnset 36, ANCIENTPOWER ; Worry Seed → event move
	learnset 39, HEALINGLIGHT ; Synthesis → similar move
	learnset 44, SEED_BOMB
	learnset 50, SLUDGE_BOMB ; TM move

	evos_attacks Venusaur
	learnset 1, PETAL_DANCE ; evolution move
	learnset 1, OUTRAGE ; HGSS tutor move
	learnset 1, TACKLE
	learnset 3, GROWL
	learnset 7, LEECH_SEED
	learnset 9, VINE_WHIP
	learnset 13, POISONPOWDER
	learnset 13, SLEEP_POWDER
	learnset 15, MUD_SLAP ; Take Down → GSC TM move
	learnset 20, RAZOR_LEAF
	learnset 23, TAKE_DOWN ; Sweet Scent → Take Down
	learnset 28, GROWTH
	learnset 31, DOUBLE_EDGE
	learnset 39, ANCIENTPOWER ; Worry Seed → event move
	learnset 45, HEALINGLIGHT ; Synthesis → similar move
	learnset 50, SEED_BOMB
	learnset 53, SLUDGE_BOMB ; Solar Beam → Sludge Bomb
	learnset 60, SOLAR_BEAM

	evos_attacks Charmander
	evo_data EVOLVE_LEVEL, 16, CHARMELEON
	learnset 1, SCRATCH
	learnset 1, GROWL
	learnset 7, EMBER
	learnset 10, SMOKESCREEN
	learnset 16, METAL_CLAW ; Dragon Rage → TM move
	learnset 19, DRAGON_RAGE ; Scary Face → Dragon Rage
	learnset 25, SCARY_FACE ; Fire Fang → Scary Face
	learnset 28, FLAME_CHARGE ; Flame Burst → TM move
	learnset 34, SLASH
	learnset 37, FLAMETHROWER
	learnset 43, FIRE_SPIN
	learnset 46, CRUNCH
	learnset 52, FLARE_BLITZ ; Sw/Sh move

	evos_attacks Charmeleon
	evo_data EVOLVE_LEVEL, 36, CHARIZARD
	learnset 1, SCRATCH
	learnset 1, GROWL
	learnset 7, EMBER
	learnset 10, SMOKESCREEN
	learnset 17, METAL_CLAW ; Dragon Rage → TM move
	learnset 21, DRAGON_RAGE ; Scary Face → Dragon Rage
	learnset 28, SCARY_FACE ; Fire Fang → Scary Face
	learnset 32, FLAME_CHARGE ; Flame Burst → TM move
	learnset 39, SLASH
	learnset 43, FLAMETHROWER
	learnset 50, FIRE_SPIN
	learnset 54, CRUNCH
	learnset 61, FLARE_BLITZ ; Sw/Sh move

	evos_attacks Charizard
	learnset 1, WING_ATTACK ; evolution move
	learnset 1, FLARE_BLITZ
	learnset 1, DRAGONBREATH
	learnset 1, DRAGON_CLAW
	learnset 1, SHADOW_CLAW
	learnset 1, AIR_SLASH
	learnset 1, OUTRAGE ; HGSS tutor move
	learnset 1, SCRATCH
	learnset 1, GROWL
	learnset 7, EMBER
	learnset 10, SMOKESCREEN
	learnset 17, METAL_CLAW ; Dragon Rage → TM move
	learnset 21, DRAGON_RAGE ; Scary Face → Dragon Rage
	learnset 28, SCARY_FACE ; Fire Fang → Scary Face
	learnset 32, FLAME_CHARGE ; Flame Burst → TM move
	learnset 41, SLASH
	learnset 47, FLAMETHROWER
	learnset 56, FIRE_SPIN
	learnset 62, CRUNCH
	learnset 71, FLARE_BLITZ
	learnset 77, HURRICANE ; Sw/Sh move

	evos_attacks Squirtle
	evo_data EVOLVE_LEVEL, 16, WARTORTLE
	learnset 1, TACKLE
	learnset 4, LEER ; Tail Whip → similar move
	learnset 7, WATER_GUN
	learnset 10, DEFENSE_CURL ; Withdraw → similar move
	learnset 13, AQUA_JET ; Bubble → egg move
	learnset 16, BITE
	learnset 19, RAPID_SPIN
	learnset 22, PROTECT
	learnset 25, WATER_PULSE
	learnset 28, AQUA_TAIL
	learnset 31, CLOSE_COMBAT ; Skull Bash → new move
	learnset 34, MIRROR_COAT ; Iron Defense → egg move
	learnset 37, RAIN_DANCE
	learnset 40, HYDRO_PUMP
	learnset 43, SHELL_SMASH ; Sw/Sw move

	evos_attacks Wartortle
	evo_data EVOLVE_LEVEL, 36, BLASTOISE
	learnset 1, TACKLE
	learnset 4, LEER ; Tail Whip → similar move
	learnset 7, WATER_GUN
	learnset 10, DEFENSE_CURL ; Withdraw → similar move
	learnset 13, AQUA_JET ; Bubble → egg move
	learnset 16, BITE
	learnset 20, RAPID_SPIN
	learnset 24, PROTECT
	learnset 28, WATER_PULSE
	learnset 32, AQUA_TAIL
	learnset 36, CLOSE_COMBAT ; Skull Bash → new move
	learnset 40, MIRROR_COAT ; Iron Defense → egg move
	learnset 44, RAIN_DANCE
	learnset 48, HYDRO_PUMP
	learnset 52, SHELL_SMASH ; Sw/Sw move

	evos_attacks Blastoise
	learnset 1, FLASH_CANNON ; evolution move
	learnset 1, AURA_SPHERE ; new move
	learnset 1, THUNDERBOLT ; event move
	learnset 1, OUTRAGE ; HGSS tutor move
	learnset 1, TACKLE
	learnset 4, LEER ; Tail Whip → similar move
	learnset 7, WATER_GUN
	learnset 10, DEFENSE_CURL ; Withdraw → similar move
	learnset 13, AQUA_JET ; Bubble → egg move
	learnset 16, BITE
	learnset 20, RAPID_SPIN
	learnset 24, PROTECT
	learnset 28, WATER_PULSE
	learnset 32, AQUA_TAIL
	learnset 39, CLOSE_COMBAT ; Skull Bash → new move
	learnset 46, MIRROR_COAT ; Iron Defense → egg move
	learnset 53, RAIN_DANCE
	learnset 60, HYDRO_PUMP
	learnset 67, SHELL_SMASH ; Sw/Sw move
if !DEF(FAITHFUL)
	learnset 75, IRON_HEAD ; TM move
endc

	evos_attacks Caterpie
	evo_data EVOLVE_LEVEL, 7, METAPOD
	learnset 1, TACKLE
	learnset 1, STRING_SHOT
	learnset 9, BUG_BITE

	evos_attacks Metapod
	evo_data EVOLVE_LEVEL, 10, BUTTERFREE
	learnset 1, TACKLE ; Caterpie move
	learnset 1, STRING_SHOT ; Caterpie move
	learnset 1, DEFENSE_CURL ; Harden → similar move

	evos_attacks Butterfree
	learnset 1, TACKLE ; Caterpie move
	learnset 1, STRING_SHOT ; Caterpie move
	learnset 1, GUST
	learnset 11, CONFUSION
	learnset 13, POISONPOWDER
	learnset 15, STUN_SPORE
	learnset 17, SLEEP_POWDER ; Psybeam → Sleep Powder
	learnset 19, PSYBEAM ; Silver Wind → Psybeam
	learnset 23, SUPERSONIC
	learnset 25, SAFEGUARD
	learnset 29, HYPNOSIS ; Whirlwind → new move
	learnset 31, BUG_BUZZ
	learnset 35, REFLECT ; Rage Powder → RBY TM move
	learnset 37, AGILITY ; Captivate → new move
	learnset 41, TAILWIND ; Tailwind
	learnset 43, AIR_SLASH
	learnset 47, PSYCHIC_M ; Quiver Dance → TM move

	evos_attacks Weedle
	evo_data EVOLVE_LEVEL, 7, KAKUNA
	learnset 1, POISON_STING
	learnset 1, STRING_SHOT
	learnset 9, BUG_BITE

	evos_attacks Kakuna
	evo_data EVOLVE_LEVEL, 10, BEEDRILL
	learnset 1, POISON_STING ; Weedle move
	learnset 1, STRING_SHOT ; Weedle move
	learnset 1, DEFENSE_CURL ; Harden → similar move

	evos_attacks Beedrill
	learnset 1, POISON_STING ; Weedle move
	learnset 1, STRING_SHOT ; Weedle move
	learnset 1, FURY_STRIKES ; Fury Attack → similar move
	learnset 1, U_TURN ; evolution move
	learnset 14, RAGE
	learnset 17, PURSUIT
	learnset 20, BULK_UP
	learnset 23, VENOSHOCK
	learnset 26, FEINT_ATTACK ; Assurance → similar move
	learnset 29, TOXIC_SPIKES
	learnset 32, PIN_MISSILE
	learnset 35, POISON_JAB
	learnset 38, AGILITY
	learnset 41, SWORDS_DANCE ; Endeavor → TM move
	learnset 44, OUTRAGE ; Fell Stinger → LGPE move

	evos_attacks Pidgey
	evo_data EVOLVE_LEVEL, 18, PIDGEOTTO
	learnset 1, TACKLE
	learnset 5, GUST ; Sand Attack → Gust
	learnset 9, MUD_SLAP ; Gust → GSC TM move
	learnset 13, QUICK_ATTACK
	learnset 17, RAGE ; Whirlwind → RBY TM move
	learnset 21, CHARM ; Twister → egg move
	learnset 25, SWIFT ; Feather Dance → TM move
	learnset 29, AGILITY
	learnset 33, WING_ATTACK
	learnset 37, ROOST
	learnset 41, TAILWIND ; Tailwind
	learnset 45, STEEL_WING ; Mirror Move → TM move
	learnset 49, AIR_SLASH
	learnset 53, HURRICANE

	evos_attacks Pidgeotto
	evo_data EVOLVE_LEVEL, 36, PIDGEOT
	learnset 1, TACKLE
	learnset 5, GUST ; Sand Attack → Gust
	learnset 9, MUD_SLAP ; Gust → GSC TM move
	learnset 13, QUICK_ATTACK
	learnset 17, RAGE ; Whirlwind → RBY TM move
	learnset 22, CHARM ; Twister → egg move
	learnset 27, SWIFT ; Feather Dance → TM move
	learnset 32, AGILITY
	learnset 37, WING_ATTACK
	learnset 42, ROOST
	learnset 47, TAILWIND ; Tailwind
	learnset 52, STEEL_WING ; Mirror Move → TM move
	learnset 57, AIR_SLASH
	learnset 62, HURRICANE

	evos_attacks Pidgeot
	learnset 1, TACKLE
	learnset 5, MUD_SLAP ; Sand Attack → similar move
	learnset 9, GUST
	learnset 13, QUICK_ATTACK
	learnset 17, RAGE ; Whirlwind → RBY TM move
	learnset 22, CHARM ; Twister → egg move
	learnset 27, SWIFT ; Feather Dance → TM move
	learnset 32, AGILITY
	learnset 38, WING_ATTACK
	learnset 44, ROOST
	learnset 50, TAILWIND ; Tailwind
	learnset 56, STEEL_WING ; Mirror Move → TM move
	learnset 62, AIR_SLASH
	learnset 68, HURRICANE

	evos_attacks RattataPlain
	evo_data EVOLVE_LEVEL, 20, RATICATE
	learnset 1, TACKLE
	learnset 4, QUICK_ATTACK
	learnset 10, BITE
	learnset 13, PURSUIT
	learnset 16, PAYBACK
	learnset 22, CRUNCH
	learnset 25, SUCKER_PUNCH
	learnset 28, SUPER_FANG
	learnset 31, DOUBLE_EDGE
	evos_attacks RattataAlolan
	evo_data EVOLVE_LEVEL, 20, RATICATE, ALOLAN_FORM
	learnset 1, TACKLE
	learnset 1, LEER ; Tail Whip → similar move
	learnset 4, QUICK_ATTACK
	learnset 7, BULK_UP
	learnset 10, BITE
	learnset 13, PURSUIT
	learnset 16, PAYBACK
	learnset 19, SUCKER_PUNCH
	learnset 22, CRUNCH
	learnset 25, FEINT_ATTACK ; Assurance → similar move
	learnset 28, SUPER_FANG
	learnset 31, DOUBLE_EDGE
	learnset 34, COUNTER ; Endeavor → egg move

	evos_attacks RaticatePlain
	learnset 0, SCARY_FACE
	learnset 1, QUICK_ATTACK
	learnset 1, SWORDS_DANCE
	learnset 1, TACKLE
	learnset 10, BITE
	learnset 13, PURSUIT
	learnset 16, PAYBACK
	learnset 24, CRUNCH
	learnset 29, SUCKER_PUNCH
	learnset 34, SUPER_FANG
	learnset 39, DOUBLE_EDGE
	evos_attacks Spearow
	evo_data EVOLVE_LEVEL, 20, FEAROW
	learnset 1, PECK
	learnset 1, GROWL
	learnset 4, LEER
	learnset 8, PURSUIT
	learnset 11, FURY_STRIKES ; Fury Attack → similar move
	learnset 15, AERIAL_ACE
	learnset 18, SWIFT ; Mirror Move → TM move
	learnset 22, FEINT_ATTACK ; Assurance → similar move
	learnset 25, AGILITY
	learnset 29, BULK_UP
	learnset 32, ROOST
	learnset 36, DRILL_PECK

	evos_attacks Fearow
	learnset 1, QUICK_ATTACK ; Pluck → egg move
	learnset 1, PECK
	learnset 1, GROWL
	learnset 4, LEER
	learnset 8, PURSUIT
	learnset 11, FURY_STRIKES ; Fury Attack → similar move
	learnset 15, AERIAL_ACE
	learnset 18, SWIFT ; Mirror Move → TM move
	learnset 23, FEINT_ATTACK ; Assurance → similar move
	learnset 27, AGILITY
	learnset 32, BULK_UP
	learnset 36, ROOST
	learnset 41, DRILL_PECK
	learnset 45, DOUBLE_EDGE ; Drill Run → tutor move

	evos_attacks Ekans
	evo_data EVOLVE_LEVEL, 22, ARBOK, NO_FORM ; preserve pre-evo form
	learnset 1, LEER
	learnset 1, WRAP
	learnset 4, POISON_STING
	learnset 9, BITE
	learnset 12, GLARE
	learnset 17, SCREECH
	learnset 20, ACID
	learnset 33, SLUDGE_BOMB
	learnset 41, HAZE
	learnset 49, GUNK_SHOT
	evos_attacks Arbok
	learnset 0, CRUNCH
	learnset 1, BITE
	learnset 1, LEER
	learnset 1, POISON_STING
	learnset 1, WRAP
	learnset 12, GLARE
	learnset 17, SCREECH
	learnset 20, ACID
	learnset 39, SLUDGE_BOMB
	learnset 51, HAZE
	learnset 63, GUNK_SHOT
	evos_attacks Pikachu
	evo_data EVOLVE_ITEM, THUNDERSTONE, RAICHU, PLAIN_FORM
	evo_data EVOLVE_ITEM, ODD_SOUVENIR, RAICHU, ALOLAN_FORM
	learnset 1, CHARM
	learnset 1, GROWL
	learnset 1, NASTY_PLOT
	learnset 1, QUICK_ATTACK
	learnset 1, SWEET_KISS
	learnset 1, THUNDERSHOCK
	learnset 4, THUNDER_WAVE
	learnset 8, DOUBLE_TEAM
	learnset 20, SPARK
	learnset 24, AGILITY
	learnset 28, IRON_TAIL
	learnset 36, THUNDERBOLT
	learnset 40, LIGHT_SCREEN
	learnset 44, THUNDER
	evos_attacks RaichuPlain
	learnset 0, THUNDERPUNCH
	learnset 1, AGILITY
	learnset 1, CHARM
	learnset 1, DOUBLE_TEAM
	learnset 1, GROWL
	learnset 1, IRON_TAIL
	learnset 1, LIGHT_SCREEN
	learnset 1, NASTY_PLOT
	learnset 1, QUICK_ATTACK
	learnset 1, SPARK
	learnset 1, SWEET_KISS
	learnset 1, THUNDER
	learnset 1, THUNDERSHOCK
	learnset 1, THUNDER_WAVE
	learnset 5, THUNDERBOLT
	evos_attacks RaichuAlolan
	learnset 1, THUNDERSHOCK
	learnset 1, LEER ; Tail Whip → similar move
	learnset 1, QUICK_ATTACK
	learnset 1, THUNDERBOLT
	learnset 1, PSYCHIC_M ; evolution move
	learnset 1, REVERSAL ; Sw/Sh move

	evos_attacks SandshrewPlain
	evo_data EVOLVE_LEVEL, 22, SANDSLASH, PLAIN_FORM
	learnset 1, SCRATCH
	learnset 1, DEFENSE_CURL
	learnset 3, MUD_SLAP ; Sand Attack → similar move
	learnset 5, POISON_STING
	learnset 7, ROLLOUT
	learnset 9, RAPID_SPIN
	learnset 11, PIN_MISSILE ; Fury Cutter → new move
	learnset 14, MAGNITUDE
	learnset 17, SWIFT
	learnset 20, FURY_STRIKES ; Fury Swipes → similar move
	learnset 23, METAL_CLAW ; Sand Tomb → HGSS tutor move
	learnset 26, SLASH
	learnset 30, DIG
	learnset 34, GYRO_BALL
	learnset 38, SWORDS_DANCE
	learnset 42, SANDSTORM
	learnset 46, EARTHQUAKE

	evos_attacks SandshrewAlolan
	evo_data EVOLVE_ITEM, ICE_STONE, SANDSLASH, ALOLAN_FORM
	learnset 1, SCRATCH
	learnset 1, DEFENSE_CURL
	learnset 3, BULK_UP ; Bide → new move
	learnset 5, ICY_WIND ; Powder Snow → similar move
	learnset 7, DEFENSE_CURL ; Ice Ball → TM move
	learnset 9, RAPID_SPIN
	learnset 11, PIN_MISSILE ; Fury Cutter → new move
	learnset 14, METAL_CLAW
	learnset 17, SWIFT
	learnset 20, FURY_STRIKES ; Fury Swipes → similar move
	learnset 23, ROLLOUT ; Iron Defense → TM move
	learnset 26, SLASH
	learnset 30, IRON_HEAD
	learnset 34, GYRO_BALL
	learnset 38, SWORDS_DANCE
	learnset 42, HAIL
	learnset 46, BLIZZARD

	evos_attacks SandslashPlain
	learnset 1, SCRATCH
	learnset 1, SLASH ; Crush Claw → Slash ; evolution move
	learnset 1, DEFENSE_CURL
	learnset 3, MUD_SLAP ; Sand Attack → similar move
	learnset 5, POISON_STING
	learnset 7, ROLLOUT
	learnset 9, RAPID_SPIN
	learnset 11, PIN_MISSILE ; Fury Cutter → new move
	learnset 14, MAGNITUDE
	learnset 17, SWIFT
	learnset 20, FURY_STRIKES ; Fury Swipes → similar move
	learnset 24, SUPER_FANG ; Sand Tomb → HGSS tutor move
	learnset 28, METAL_CLAW ; Slash → TM move
	learnset 33, DIG
	learnset 38, GYRO_BALL
	learnset 43, SWORDS_DANCE
	learnset 48, SANDSTORM
	learnset 53, EARTHQUAKE

	evos_attacks SandslashAlolan
	learnset 1, ICICLE_SPEAR ; evolution move
	learnset 1, COUNTER ; Metal Burst → similar move
	learnset 1, MIRROR_COAT ; Metal Burst → similar move
	learnset 1, ICICLE_CRASH ; evolution move
	learnset 1, SLASH
	learnset 1, DEFENSE_CURL
	learnset 1, ROLLOUT ; Ice Ball → TM move
	learnset 1, METAL_CLAW
	learnset 48, HAIL
	learnset 53, BLIZZARD

	evos_attacks NidoranF
	evo_data EVOLVE_LEVEL, 16, NIDORINA
	learnset 1, GROWL
	learnset 1, POISON_STING
	learnset 5, SCRATCH
	learnset 15, FURY_STRIKES
	learnset 20, TOXIC_SPIKES
	learnset 25, DOUBLE_KICK
	learnset 30, BITE
	learnset 40, TOXIC
	learnset 50, CRUNCH
	learnset 55, EARTH_POWER
	evos_attacks Nidorina
	evo_data EVOLVE_ITEM, MOON_STONE, NIDOQUEEN
	learnset 1, GROWL
	learnset 1, POISON_STING
	learnset 1, SCRATCH
	learnset 15, FURY_STRIKES
	learnset 22, TOXIC_SPIKES
	learnset 29, DOUBLE_KICK
	learnset 36, BITE
	learnset 50, TOXIC
	learnset 64, CRUNCH
	learnset 71, EARTH_POWER
	evos_attacks Nidoqueen
	learnset 1, BITE
	learnset 1, CRUNCH
	learnset 1, DOUBLE_KICK
	learnset 1, EARTH_POWER
	learnset 1, FURY_STRIKES
	learnset 1, GROWL
	learnset 1, POISON_STING
	learnset 1, SCRATCH
	learnset 1, TOXIC
	learnset 1, TOXIC_SPIKES
	evos_attacks NidoranM
	evo_data EVOLVE_LEVEL, 16, NIDORINO
	learnset 1, LEER
	learnset 1, POISON_STING
	learnset 5, PECK
	learnset 20, TOXIC_SPIKES
	learnset 25, DOUBLE_KICK
	learnset 30, HORN_ATTACK
	learnset 40, TOXIC
	learnset 50, POISON_JAB
	learnset 55, EARTH_POWER
	evos_attacks Nidorino
	evo_data EVOLVE_ITEM, MOON_STONE, NIDOKING
	learnset 1, LEER
	learnset 1, PECK
	learnset 1, POISON_STING
	learnset 22, TOXIC_SPIKES
	learnset 29, DOUBLE_KICK
	learnset 36, HORN_ATTACK
	learnset 50, TOXIC
	learnset 64, POISON_JAB
	learnset 71, EARTH_POWER
	evos_attacks Nidoking
	learnset 0, MEGAHORN
	learnset 1, DOUBLE_KICK
	learnset 1, EARTH_POWER
	learnset 1, HORN_ATTACK
	learnset 1, LEER
	learnset 1, PECK
	learnset 1, POISON_JAB
	learnset 1, POISON_STING
	learnset 1, TOXIC
	learnset 1, TOXIC_SPIKES
	evos_attacks Clefairy
	evo_data EVOLVE_ITEM, MOON_STONE, CLEFABLE
	learnset 1, CHARM
	learnset 1, DEFENSE_CURL
	learnset 1, DISARM_VOICE
	learnset 1, GROWL
	learnset 1, SING
	learnset 1, SPLASH
	learnset 1, SWEET_KISS
	learnset 8, ENCORE
	learnset 20, METRONOME
	learnset 44, MOONBLAST
	evos_attacks Clefable
	learnset 1, METRONOME
	learnset 1, MOONBLAST
	evos_attacks VulpixPlain
	evo_data EVOLVE_ITEM, FIRE_STONE, NINETALES, PLAIN_FORM
	learnset 1, EMBER
	learnset 4, DISABLE
	learnset 8, QUICK_ATTACK
	learnset 20, CONFUSE_RAY
	learnset 24, WILL_O_WISP
	learnset 28, EXTRASENSORY
	learnset 32, FLAMETHROWER
	learnset 40, FIRE_SPIN
	learnset 44, SAFEGUARD
	learnset 52, FIRE_BLAST
	evos_attacks VulpixAlolan
	evo_data EVOLVE_ITEM, ICE_STONE, NINETALES, ALOLAN_FORM
	learnset 1, ICY_WIND ; Powder Snow → similar move
	learnset 4, GROWL ; Tail Whip → new move
	learnset 7, ROAR
	learnset 9, CHARM ; Baby-Doll Eyes → similar move
	learnset 10, ICE_SHARD
	learnset 12, CONFUSE_RAY
	learnset 15, DISARM_VOICE ; Icy Wind → new move
	learnset 18, NIGHT_SHADE ; Payback → new move
	learnset 20, HAIL ; Mist → TM move
	learnset 23, FEINT_ATTACK
	learnset 26, HEX
	learnset 28, AURORA_BEAM
	learnset 31, EXTRASENSORY
	learnset 34, SAFEGUARD
	learnset 36, ICE_BEAM
	learnset 39, HYPNOSIS ; Imprison → egg move
	learnset 42, BLIZZARD
	learnset 44, SHADOW_BALL ; Grudge → TM move
	learnset 47, DISABLE ; Captivate → egg move
	learnset 50, MOONBLAST ; Sheer Cold → egg move
	learnset 53, HEALINGLIGHT ; new move

	evos_attacks NinetalesPlain
	learnset 1, FLAMETHROWER
	learnset 1, QUICK_ATTACK
	evos_attacks NinetalesAlolan
	learnset 1, DAZZLINGLEAM ; evolution move
	learnset 1, NASTY_PLOT
	learnset 1, ICE_BEAM
	learnset 1, ICE_SHARD
	learnset 1, CONFUSE_RAY
	learnset 1, SAFEGUARD

	evos_attacks Jigglypuff
	evo_data EVOLVE_ITEM, MOON_STONE, WIGGLYTUFF
	learnset 1, SING
	learnset 1, SWEET_KISS ; Igglybuff move
	learnset 3, DEFENSE_CURL
	learnset 5, TACKLE ; Pound → similar move
	learnset 9, DIZZY_PUNCH ; Play Nice → Crystal unique move
	learnset 11, DISARM_VOICE
	learnset 14, DISABLE
	learnset 17, DOUBLE_SLAP
	learnset 20, ROLLOUT
	learnset 22, CHARM ; Round → Igglybuff move
	learnset 27, MEAN_LOOK ; Wake-Up Slap → new move
	learnset 30, REST
	learnset 32, BODY_SLAM
	learnset 35, GYRO_BALL
	learnset 38, HEAL_BELL ; Mimic → HGSS tutor move
	learnset 41, HYPER_VOICE
	learnset 45, DOUBLE_EDGE

	evos_attacks Wigglytuff
	learnset 1, MINIMIZE ; LGPE move
	learnset 1, NASTY_PLOT ; SV TM move
	learnset 1, DOUBLE_EDGE
	learnset 1, PLAY_ROUGH
	learnset 1, SING
	learnset 1, DEFENSE_CURL
	learnset 1, DISABLE
	learnset 1, DOUBLE_SLAP

	evos_attacks Zubat
	evo_data EVOLVE_LEVEL, 22, GOLBAT
	learnset 1, ABSORB
	learnset 1, SUPERSONIC
	learnset 5, ASTONISH
	learnset 10, MEAN_LOOK
	learnset 30, BITE
	learnset 35, HAZE
	learnset 40, VENOSHOCK
	learnset 45, CONFUSE_RAY
	learnset 50, AIR_SLASH
	learnset 55, LEECH_LIFE
	evos_attacks Golbat
	evo_data EVOLVE_HAPPINESS, TR_ANYTIME, CROBAT
	learnset 1, ABSORB
	learnset 1, ASTONISH
	learnset 1, MEAN_LOOK
	learnset 1, SCREECH
	learnset 1, SUPERSONIC
	learnset 34, BITE
	learnset 41, HAZE
	learnset 48, VENOSHOCK
	learnset 55, CONFUSE_RAY
	learnset 62, AIR_SLASH
	learnset 69, LEECH_LIFE
	evos_attacks Oddish
	evo_data EVOLVE_LEVEL, 21, GLOOM
	learnset 1, ABSORB
	learnset 1, GROWTH
	learnset 4, ACID
	learnset 12, MEGA_DRAIN
	learnset 14, POISONPOWDER
	learnset 16, STUN_SPORE
	learnset 18, SLEEP_POWDER
	learnset 20, GIGA_DRAIN
	learnset 24, TOXIC
	learnset 28, MOONBLAST
	learnset 40, PETAL_DANCE
	evos_attacks Gloom
	evo_data EVOLVE_ITEM, LEAF_STONE, VILEPLUME
	evo_data EVOLVE_ITEM, SUN_STONE, BELLOSSOM
	learnset 1, ABSORB
	learnset 1, ACID
	learnset 1, GROWTH
	learnset 12, MEGA_DRAIN
	learnset 14, POISONPOWDER
	learnset 16, STUN_SPORE
	learnset 18, SLEEP_POWDER
	learnset 20, GIGA_DRAIN
	learnset 26, TOXIC
	learnset 32, MOONBLAST
	learnset 50, PETAL_DANCE
	evos_attacks Vileplume
	learnset 1, ABSORB
	learnset 1, ACID
	learnset 1, GIGA_DRAIN
	learnset 1, GROWTH
	learnset 1, MEGA_DRAIN
	learnset 1, MOONBLAST
	learnset 1, PETAL_DANCE
	learnset 1, POISONPOWDER
	learnset 1, SLEEP_POWDER
	learnset 1, STUN_SPORE
	learnset 1, TOXIC
	evos_attacks Paras
	evo_data EVOLVE_LEVEL, 24, PARASECT
	learnset 1, SCRATCH
	learnset 6, POISONPOWDER
	learnset 6, STUN_SPORE
	learnset 11, ABSORB
	learnset 22, SPORE
	learnset 27, SLASH
	learnset 33, GROWTH
	learnset 38, GIGA_DRAIN
	learnset 54, X_SCISSOR
	evos_attacks Parasect
	learnset 1, ABSORB
	learnset 1, POISONPOWDER
	learnset 1, SCRATCH
	learnset 1, STUN_SPORE
	learnset 22, SPORE
	learnset 29, SLASH
	learnset 37, GROWTH
	learnset 44, GIGA_DRAIN
	learnset 66, X_SCISSOR
	evos_attacks Venonat
	evo_data EVOLVE_LEVEL, 31, VENOMOTH
	learnset 1, DISABLE
	learnset 1, TACKLE
	learnset 5, SUPERSONIC
	learnset 11, CONFUSION
	learnset 13, POISONPOWDER
	learnset 17, PSYBEAM
	learnset 23, STUN_SPORE
	learnset 25, BUG_BUZZ
	learnset 29, SLEEP_POWDER
	learnset 35, LEECH_LIFE
	learnset 37, ZEN_HEADBUTT
	learnset 47, PSYCHIC_M
	evos_attacks Venomoth
	learnset 0, AIR_SLASH
	learnset 1, DISABLE
	learnset 1, SUPERSONIC
	learnset 1, TACKLE
	learnset 11, CONFUSION
	learnset 13, POISONPOWDER
	learnset 17, PSYBEAM
	learnset 23, STUN_SPORE
	learnset 25, BUG_BUZZ
	learnset 29, SLEEP_POWDER
	learnset 37, LEECH_LIFE
	learnset 41, ZEN_HEADBUTT
	learnset 55, PSYCHIC_M
	evos_attacks DiglettPlain
	evo_data EVOLVE_LEVEL, 26, DUGTRIO, PLAIN_FORM
	learnset 1, SCRATCH
	learnset 4, GROWL
	learnset 8, ASTONISH
	learnset 12, MUD_SLAP
	learnset 16, BULLDOZE
	learnset 20, SUCKER_PUNCH
	learnset 24, SLASH
	learnset 28, SANDSTORM
	learnset 32, DIG
	learnset 36, EARTH_POWER
	learnset 40, EARTHQUAKE
	evos_attacks DiglettAlolan
	evo_data EVOLVE_LEVEL, 26, DUGTRIO, ALOLAN_FORM
	learnset 1, MUD_SLAP ; Sand Attack → Mud-Slap
	learnset 1, METAL_CLAW
	learnset 1, CHARM ; XD move
	learnset 4, GROWL
	learnset 7, ASTONISH
	learnset 10, AGILITY ; Mud-Slap → LGPE move
	learnset 14, MAGNITUDE
	learnset 18, BULLDOZE
	learnset 22, SUCKER_PUNCH
	learnset 25, ANCIENTPOWER ; Mud Bomb → egg move
	learnset 28, EARTH_POWER
	learnset 31, DIG
	learnset 35, IRON_HEAD
	learnset 39, EARTHQUAKE
	learnset 43, NIGHT_SLASH ; Fissure → Dugtrio move

	evos_attacks DugtrioPlain
	learnset 1, ASTONISH
	learnset 1, GROWL
	learnset 1, NIGHT_SLASH
	learnset 1, SCRATCH
	learnset 1, TRI_ATTACK
	learnset 12, MUD_SLAP
	learnset 16, BULLDOZE
	learnset 20, SUCKER_PUNCH
	learnset 24, SLASH
	learnset 30, SANDSTORM
	learnset 36, DIG
	learnset 42, EARTH_POWER
	learnset 48, EARTHQUAKE
	evos_attacks DugtrioAlolan
	learnset 1, TRI_ATTACK ; Sand Tomb → Tri Attack ; evolution move
	learnset 1, NIGHT_SLASH
	learnset 1, MUD_SLAP ; Sand Attack → Mud-Slap
	learnset 1, METAL_CLAW
	learnset 1, CHARM ; XD move
	learnset 4, GROWL
	learnset 7, ASTONISH
	learnset 10, AGILITY ; Mud-Slap → LGPE move
	learnset 14, MAGNITUDE
	learnset 18, BULLDOZE
	learnset 22, SUCKER_PUNCH
	learnset 25, ANCIENTPOWER ; Mud Bomb → egg move
	learnset 30, EARTH_POWER
	learnset 35, DIG
	learnset 41, IRON_HEAD
	learnset 47, EARTHQUAKE
	learnset 53, NIGHT_SLASH ; Fissure → Night Slash

	evos_attacks MeowthPlain
	evo_data EVOLVE_LEVEL, 28, PERSIAN, PLAIN_FORM
	learnset 1, FAKE_OUT
	learnset 1, GROWL
	learnset 8, SCRATCH
	learnset 12, PAY_DAY
	learnset 16, BITE
	learnset 20, TAUNT
	learnset 29, FURY_STRIKES
	learnset 32, SCREECH
	learnset 36, FEINT
	learnset 40, NASTY_PLOT
	learnset 44, PLAY_ROUGH
	evos_attacks MeowthAlolan
	evo_data EVOLVE_LEVEL, 28, PERSIAN, ALOLAN_FORM
	learnset 1, SCRATCH
	learnset 1, GROWL
	learnset 6, BITE
	learnset 9, FAKE_OUT
	learnset 14, FURY_STRIKES ; Fury Swipes → similar move
	learnset 17, SCREECH
	learnset 20, TAUNT
	learnset 22, FEINT
	learnset 28, PAY_DAY
	learnset 33, SLASH
	learnset 38, NASTY_PLOT
	learnset 41, THIEF ; Assurance → TM move
	learnset 46, CHARM ; Captivate → egg move
	learnset 49, NIGHT_SLASH
	learnset 55, DARK_PULSE

	evos_attacks MeowthGalarian
	evo_data EVOLVE_LEVEL, 28, PERRSERKER, PLAIN_FORM
	learnset 1, FAKE_OUT
	learnset 1, GROWL
	learnset 4, HONE_CLAWS
	learnset 8, SCRATCH
	learnset 12, PAY_DAY
	learnset 16, METAL_CLAW
	learnset 20, PURSUIT ; Taunt → new move
	learnset 24, SWAGGER
	learnset 29, FURY_STRIKES ; Fury Swipes → similar move
	learnset 32, SCREECH
	learnset 36, SLASH
	learnset 40, CRUNCH ; Metal Sound → TR move
	learnset 44, THRASH

	evos_attacks PersianPlain
	learnset 0, POWER_GEM
	learnset 1, FAKE_OUT
	learnset 1, GROWL
	learnset 1, SCRATCH
	learnset 12, PAY_DAY
	learnset 16, BITE
	learnset 20, TAUNT
	learnset 31, FURY_STRIKES
	learnset 36, SCREECH
	learnset 40, FEINT
	learnset 48, NASTY_PLOT
	learnset 54, PLAY_ROUGH
	evos_attacks PersianAlolan
	learnset 1, BUBBLE_BEAM ; RBY TM move
	learnset 1, PLAY_ROUGH
	learnset 1, SWIFT ; evolution move
	learnset 1, SCRATCH
	learnset 1, GROWL
	learnset 6, BITE
	learnset 9, FAKE_OUT
	learnset 14, FURY_STRIKES ; Fury Swipes → similar move
	learnset 17, SCREECH
	learnset 22, FEINT
	learnset 25, PURSUIT ; Taunt → egg move
	learnset 32, POWER_GEM
	learnset 37, SLASH
	learnset 44, NASTY_PLOT
	learnset 49, THIEF ; Assurance → TM move
	learnset 56, CHARM ; Captivate → egg move
	learnset 61, NIGHT_SLASH
	learnset 65, DARK_PULSE

	evos_attacks Psyduck
	evo_data EVOLVE_LEVEL, 33, GOLDUCK
	learnset 1, SCRATCH
	learnset 4, LEER ; Tail Whip → similar move
	learnset 7, WATER_GUN
	learnset 10, CONFUSION
	learnset 13, FURY_STRIKES ; Fury Swipes → similar move
	learnset 16, WATER_PULSE
	learnset 19, DISABLE
	learnset 22, SCREECH
	learnset 25, ZEN_HEADBUTT
	learnset 28, AQUA_TAIL
	learnset 31, RAIN_DANCE ; Soak → TM move
	learnset 34, PSYBEAM ; Psych Up → egg move
	learnset 37, AMNESIA
	learnset 40, HYDRO_PUMP
	learnset 43, NASTY_PLOT ; Wonder Room → SV TM move
	learnset 46, PSYCHIC_M ; TM move

	evos_attacks Golduck
	learnset 1, SCRATCH
	learnset 1, AQUA_JET
	learnset 4, LEER ; Tail Whip → similar move
	learnset 7, WATER_GUN
	learnset 10, CONFUSION
	learnset 13, FURY_STRIKES ; Fury Swipes → similar move
	learnset 16, WATER_PULSE
	learnset 19, DISABLE
	learnset 22, SCREECH
	learnset 25, ZEN_HEADBUTT
	learnset 28, AQUA_TAIL
	learnset 31, RAIN_DANCE ; Soak → TM move
	learnset 36, PSYBEAM ; Psych Up → egg move
	learnset 41, AMNESIA
	learnset 46, HYDRO_PUMP
	learnset 51, NASTY_PLOT ; Wonder Room → SV TM move
	learnset 56, PSYCHIC_M ; TM move

	evos_attacks Mankey
	evo_data EVOLVE_LEVEL, 28, PRIMEAPE
	learnset 1, SCRATCH
	learnset 1, LOW_KICK
	learnset 1, LEER
	learnset 1, BULK_UP
	learnset 5, FURY_STRIKES ; Fury Swipes → similar move
	learnset 8, KARATE_CHOP
	learnset 12, PURSUIT
	learnset 15, SEISMIC_TOSS
	learnset 19, SWAGGER
	learnset 22, CROSS_CHOP
	learnset 26, REVERSAL ; Assurance → egg move
	learnset 29, FEINT_ATTACK ; Punishment → new move
	learnset 33, THRASH
	learnset 36, CLOSE_COMBAT
	learnset 40, SCREECH
	learnset 43, GUNK_SHOT ; Stomping Tantrum → HGSS tutor move
	learnset 47, OUTRAGE

	evos_attacks Primeape
	evo_data EVOLVE_MOVE, OUTRAGE, ANNIHILAPE
	learnset 1, OUTRAGE
	learnset 1, RAGE ; evolution move
	learnset 1, SCRATCH
	learnset 1, LOW_KICK
	learnset 1, LEER
	learnset 1, BULK_UP
	learnset 5, FURY_STRIKES ; Fury Swipes → similar move
	learnset 8, KARATE_CHOP
	learnset 12, PURSUIT
	learnset 15, SEISMIC_TOSS
	learnset 19, SWAGGER
	learnset 22, CROSS_CHOP
	learnset 26, REVERSAL ; Assurance → egg move
	learnset 30, FEINT_ATTACK ; Punishment → new move
	learnset 35, THRASH
	learnset 39, CLOSE_COMBAT
	learnset 44, SCREECH
	learnset 48, GUNK_SHOT ; Stomping Tantrum → HGSS tutor move
	learnset 53, OUTRAGE

	evos_attacks GrowlithePlain
	evo_data EVOLVE_ITEM, FIRE_STONE, ARCANINE
	learnset 1, EMBER
	learnset 1, LEER
	learnset 8, BITE
	learnset 20, AGILITY
	learnset 32, CRUNCH
	learnset 36, TAKE_DOWN
	learnset 40, FLAMETHROWER
	learnset 44, ROAR
	learnset 48, PLAY_ROUGH
	learnset 52, REVERSAL
	learnset 56, FLARE_BLITZ
	evos_attacks ArcaninePlain
	learnset 0, EXTREMESPEED
	learnset 1, AGILITY
	learnset 1, BITE
	learnset 1, CRUNCH
	learnset 1, EMBER
	learnset 1, FLARE_BLITZ
	learnset 1, LEER
	learnset 1, PLAY_ROUGH
	learnset 1, REVERSAL
	learnset 1, ROAR
	learnset 1, TAKE_DOWN
	learnset 5, FLAMETHROWER
	evos_attacks GrowlitheHisuian
	evo_data EVOLVE_ITEM, FIRE_STONE, ARCANINE, HISUIAN_FORM
	learnset 1, GROWL
	learnset 1, BITE
	learnset 1, ROAR
	learnset 6, EMBER
	learnset 8, LEER
	learnset 10, SAFEGUARD ; Odor Sleuth → egg move
	learnset 12, BATON_PASS ; Helping Hand → new move
	learnset 17, FIRE_SPIN ; Flame Wheel → egg move
	learnset 19, REVERSAL
	learnset 21, ROCK_BLAST ; Fire Fang → new move
	learnset 23, TAKE_DOWN
	learnset 28, FLAME_CHARGE ; Flame Burst → TM move
	learnset 30, AGILITY
	learnset 32, ROCK_SLIDE
	learnset 34, FLAMETHROWER
	learnset 39, CRUNCH
	learnset 41, POWER_GEM ; Heat Wave → new move
	learnset 43, OUTRAGE
	learnset 45, PLAY_ROUGH ; Flare Blitz → LGPE move
	learnset 49, FLARE_BLITZ

	evos_attacks ArcanineHisuian
	learnset 1, BULK_UP ; new move
	learnset 1, GROWL
	learnset 1, BITE
	learnset 1, ROAR
	learnset 1, FLAME_CHARGE
	learnset 1, TAKE_DOWN
	learnset 1, EXTREMESPEED ; evolution move

	evos_attacks Poliwag
	evo_data EVOLVE_LEVEL, 25, POLIWHIRL
	learnset 1, SWEET_KISS ; event move
	learnset 1, WATER_GUN ; Water Sport → Water Gun
	learnset 5, HYPNOSIS ; Water Gun → Hypnosis
	learnset 8, DOUBLE_SLAP ; Hypnosis → Double Slap
	learnset 11, AQUA_JET ; Bubble → new move
	learnset 15, MUD_SLAP ; Double Slap → TM move
	learnset 18, RAIN_DANCE
	learnset 21, BODY_SLAM
	learnset 25, BUBBLE_BEAM
	learnset 28, LOW_KICK ; Mud Shot → LGPE move
	learnset 31, BELLY_DRUM
	learnset 35, GROWTH ; Wake-Up Slap → event move
	learnset 38, HYDRO_PUMP
	learnset 41, EARTH_POWER ; Mud Bomb → similar move

	evos_attacks Poliwhirl
	evo_data EVOLVE_TRADE, KINGS_ROCK, POLITOED
	evo_data EVOLVE_ITEM, WATER_STONE, POLIWRATH
	learnset 1, SWEET_KISS ; event move
	learnset 1, WATER_GUN ; Water Sport → Water Gun
	learnset 5, HYPNOSIS ; Water Gun → Hypnosis
	learnset 8, DOUBLE_SLAP ; Hypnosis → Double Slap
	learnset 11, AQUA_JET ; Bubble → new move
	learnset 15, MUD_SLAP ; Double Slap → TM move
	learnset 18, RAIN_DANCE
	learnset 21, BODY_SLAM
	learnset 27, BUBBLE_BEAM
	learnset 32, LOW_KICK ; Mud Shot → LGPE move
	learnset 37, BELLY_DRUM
	learnset 43, GROWTH ; Wake-Up Slap → event move
	learnset 48, HYDRO_PUMP
	learnset 53, EARTH_POWER ; Mud Bomb → similar move

	evos_attacks Poliwrath
	learnset 1, BUBBLE_BEAM
	learnset 1, HYPNOSIS
	learnset 1, DOUBLE_SLAP
	learnset 1, CLOSE_COMBAT ; evolution move
	learnset 32, DYNAMICPUNCH
	learnset 43, EARTH_POWER ; Mind Reader → Poliwhirl move
	learnset 53, CROSS_CHOP ; Circle Throw → similar move

	evos_attacks Abra
	evo_data EVOLVE_LEVEL, 16, KADABRA
	learnset 1, TELEPORT

	evos_attacks Kadabra
	evo_data EVOLVE_TRADE, LINKING_CORD, ALAKAZAM
	learnset 1, TELEPORT
	learnset 1, FORESIGHT ; evolution move
	learnset 16, CONFUSION
	learnset 18, DISABLE
	learnset 21, PSYBEAM
	learnset 23, NIGHT_SHADE ; Miracle Eye → LGPE move
	learnset 26, REFLECT
	learnset 28, LIGHT_SCREEN ; Psycho Cut → egg move
	learnset 31, RECOVER
	learnset 33, BARRIER ; Telekinesis → egg move
	learnset 36, BATON_PASS ; Ally Switch → new move
	learnset 38, PSYCHIC_M
	learnset 41, CALM_MIND
	learnset 43, CONFUSE_RAY ; Role Play → new move
	learnset 46, FUTURE_SIGHT

	evos_attacks Alakazam
	learnset 1, TRI_ATTACK ; RBY TM move
	learnset 1, TELEPORT
	learnset 1, FORESIGHT ; evolution move
	learnset 16, CONFUSION
	learnset 18, DISABLE
	learnset 21, PSYBEAM
	learnset 23, NIGHT_SHADE ; Miracle Eye → LGPE move
	learnset 26, REFLECT
	learnset 28, LIGHT_SCREEN ; Psycho Cut → egg move
	learnset 31, RECOVER
	learnset 33, BARRIER ; Telekinesis → egg move
	learnset 36, BATON_PASS ; Ally Switch → new move
	learnset 38, PSYCHIC_M
	learnset 41, CALM_MIND
	learnset 43, CONFUSE_RAY ; Role Play → new move
	learnset 46, FUTURE_SIGHT

	evos_attacks Machop
	evo_data EVOLVE_LEVEL, 28, MACHOKE
	learnset 1, LEER
	learnset 1, LOW_KICK
	learnset 16, KNOCK_OFF
	learnset 20, SCARY_FACE
	learnset 36, BULK_UP
	learnset 40, SEISMIC_TOSS
	learnset 44, DYNAMICPUNCH
	learnset 48, CROSS_CHOP
	learnset 52, DOUBLE_EDGE
	evos_attacks Machoke
	evo_data EVOLVE_TRADE, LINKING_CORD, MACHAMP
	learnset 1, LEER
	learnset 1, LOW_KICK
	learnset 16, KNOCK_OFF
	learnset 20, SCARY_FACE
	learnset 42, BULK_UP
	learnset 48, SEISMIC_TOSS
	learnset 54, DYNAMICPUNCH
	learnset 60, CROSS_CHOP
	learnset 66, DOUBLE_EDGE
	evos_attacks Machamp
	learnset 1, LEER
	learnset 1, LOW_KICK
	learnset 16, KNOCK_OFF
	learnset 20, SCARY_FACE
	learnset 42, BULK_UP
	learnset 48, SEISMIC_TOSS
	learnset 54, DYNAMICPUNCH
	learnset 60, CROSS_CHOP
	learnset 66, DOUBLE_EDGE
	evos_attacks Bellsprout
	evo_data EVOLVE_LEVEL, 21, WEEPINBELL
	learnset 1, VINE_WHIP
	learnset 7, GROWTH
	learnset 11, WRAP
	learnset 13, SLEEP_POWDER
	learnset 15, POISONPOWDER
	learnset 17, STUN_SPORE
	learnset 23, ACID
	learnset 27, KNOCK_OFF
	learnset 39, RAZOR_LEAF
	learnset 41, POISON_JAB
	learnset 52, POWER_WHIP
	evos_attacks Weepinbell
	evo_data EVOLVE_ITEM, LEAF_STONE, VICTREEBEL
	learnset 1, GROWTH
	learnset 1, VINE_WHIP
	learnset 1, WRAP
	learnset 13, SLEEP_POWDER
	learnset 15, POISONPOWDER
	learnset 17, STUN_SPORE
	learnset 24, ACID
	learnset 29, KNOCK_OFF
	learnset 44, RAZOR_LEAF
	learnset 47, POISON_JAB
	learnset 58, POWER_WHIP
	evos_attacks Victreebel
	learnset 1, RAZOR_LEAF
	learnset 1, SLEEP_POWDER
	learnset 1, VINE_WHIP
	evos_attacks Tentacool
	evo_data EVOLVE_LEVEL, 30, TENTACRUEL
	learnset 1, POISON_STING
	learnset 1, WATER_GUN
	learnset 4, ACID
	learnset 8, WRAP
	learnset 12, SUPERSONIC
	learnset 16, WATER_PULSE
	learnset 20, SCREECH
	learnset 24, BUBBLE_BEAM
	learnset 28, HEX
	learnset 36, POISON_JAB
	learnset 48, HYDRO_PUMP
	evos_attacks Tentacruel
	learnset 1, ACID
	learnset 1, POISON_STING
	learnset 1, WATER_GUN
	learnset 1, WRAP
	learnset 12, SUPERSONIC
	learnset 16, WATER_PULSE
	learnset 20, SCREECH
	learnset 24, BUBBLE_BEAM
	learnset 28, HEX
	learnset 40, POISON_JAB
	learnset 58, HYDRO_PUMP
	evos_attacks GeodudePlain
	evo_data EVOLVE_LEVEL, 25, GRAVELER, PLAIN_FORM
	learnset 1, DEFENSE_CURL
	learnset 1, TACKLE
	learnset 8, ROCK_TOMB
	learnset 10, ROLLOUT
	learnset 12, BULLDOZE
	learnset 16, ROCK_THROW
	learnset 28, STEALTH_ROCK
	learnset 30, ROCK_BLAST
	learnset 34, EARTHQUAKE
	learnset 36, EXPLOSION
	learnset 40, DOUBLE_EDGE
	learnset 42, STONE_EDGE
	evos_attacks GravelerPlain
	evo_data EVOLVE_TRADE, LINKING_CORD, GOLEM, PLAIN_FORM
	learnset 1, DEFENSE_CURL
	learnset 1, TACKLE
	learnset 10, ROLLOUT
	learnset 12, BULLDOZE
	learnset 16, ROCK_THROW
	learnset 30, STEALTH_ROCK
	learnset 34, ROCK_BLAST
	learnset 40, EARTHQUAKE
	learnset 44, EXPLOSION
	learnset 50, DOUBLE_EDGE
	learnset 54, STONE_EDGE
	evos_attacks GolemPlain
	learnset 1, DEFENSE_CURL
	learnset 1, TACKLE
	learnset 16, ROCK_THROW
	learnset 22, BULLDOZE
	learnset 30, STEALTH_ROCK
	learnset 34, ROCK_BLAST
	learnset 40, EARTHQUAKE
	learnset 44, EXPLOSION
	learnset 50, DOUBLE_EDGE
	learnset 54, STONE_EDGE
	evos_attacks GeodudeAlolan
	evo_data EVOLVE_LEVEL, 25, GRAVELER, ALOLAN_FORM
	learnset 1, TACKLE
	learnset 1, DEFENSE_CURL
	learnset 4, THUNDERSHOCK ; Charge → new move
	learnset 6, RAPID_SPIN ; Rock Polish → event move
	learnset 10, ROLLOUT
	learnset 12, SPARK
	learnset 16, ROCK_THROW
	learnset 18, ANCIENTPOWER ; Smack Down → HGSS tutor move
	learnset 22, THUNDERPUNCH
	learnset 24, ROCK_BLAST ; Self-Destruct → Rock Blast
	learnset 28, SANDSTORM ; Stealth Rock → TM move
	learnset 30, ROCK_SLIDE ; Rock Blast → TM move
	learnset 34, WILD_CHARGE ; Discharge → new move
	learnset 36, EXPLOSION
	learnset 40, DOUBLE_EDGE
	learnset 42, STONE_EDGE

	evos_attacks GravelerAlolan
	evo_data EVOLVE_TRADE, LINKING_CORD, GOLEM, ALOLAN_FORM
	learnset 1, TACKLE
	learnset 1, DEFENSE_CURL
	learnset 4, THUNDERSHOCK ; Charge → new move
	learnset 6, RAPID_SPIN ; Rock Polish → event move
	learnset 10, ROLLOUT
	learnset 12, SPARK
	learnset 16, ROCK_THROW
	learnset 18, ANCIENTPOWER ; Smack Down → HGSS tutor move
	learnset 22, THUNDERPUNCH
	learnset 24, ROCK_BLAST ; Self-Destruct → Rock Blast
	learnset 30, SANDSTORM ; Stealth Rock → TM move
	learnset 34, ROCK_SLIDE ; Rock Blast → TM move
	learnset 40, WILD_CHARGE ; Discharge → new move
	learnset 44, EXPLOSION
	learnset 50, DOUBLE_EDGE
	learnset 54, STONE_EDGE

	evos_attacks GolemAlolan
	learnset 1, TACKLE
	learnset 1, DEFENSE_CURL
	learnset 4, THUNDERSHOCK ; Charge → new move
	learnset 6, RAPID_SPIN ; Rock Polish → event move
	learnset 10, ROLLOUT
	learnset 12, SPARK
	learnset 16, ROCK_THROW
	learnset 18, ANCIENTPOWER ; Smack Down → HGSS tutor move
	learnset 22, THUNDERPUNCH
	learnset 24, ROCK_BLAST ; Self-Destruct → Rock Blast
	learnset 30, SANDSTORM ; Stealth Rock → TM move
	learnset 34, ROCK_SLIDE ; Rock Blast → TM move
	learnset 40, WILD_CHARGE ; Discharge → new move
	learnset 44, EXPLOSION
	learnset 50, DOUBLE_EDGE
	learnset 54, STONE_EDGE
	learnset 60, GYRO_BALL ; Heavy Slam → similar move

	evos_attacks PonytaPlain
	evo_data EVOLVE_LEVEL, 40, RAPIDASH, PLAIN_FORM
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 10, EMBER
	learnset 15, FLAME_CHARGE
	learnset 20, AGILITY
	learnset 30, STOMP
	learnset 35, FIRE_SPIN
	learnset 41, TAKE_DOWN
	learnset 50, FIRE_BLAST
	learnset 55, FLARE_BLITZ
	evos_attacks PonytaGalarian
	evo_data EVOLVE_LEVEL, 40, RAPIDASH, GALARIAN_FORM
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 4, LEER ; Tail Whip → similar move
	learnset 9, CONFUSION
	learnset 13, DISARM_VOICE ; Fairy Wind → similar move
	learnset 17, STOMP
	learnset 21, HEALINGLIGHT ; Heal Pulse → similar move
	learnset 25, PSYBEAM
	learnset 29, TAKE_DOWN
	learnset 33, DAZZLINGLEAM
	learnset 37, AGILITY
	learnset 41, PSYCHIC_M
	learnset 45, EXTREMESPEED ; Bounce → new move
	learnset 49, MOONBLAST ; Healing Wish → new move

	evos_attacks RapidashPlain
	learnset 1, EMBER
	learnset 1, GROWL
	learnset 1, MEGAHORN
	learnset 1, POISON_JAB
	learnset 1, QUICK_ATTACK
	learnset 1, TACKLE
	learnset 15, FLAME_CHARGE
	learnset 20, AGILITY
	learnset 30, STOMP
	learnset 35, FIRE_SPIN
	learnset 43, TAKE_DOWN
	learnset 56, FIRE_BLAST
	learnset 63, FLARE_BLITZ
	evos_attacks RapidashGalarian
	learnset 1, PLAY_ROUGH ; evolution move
	learnset 1, MEGAHORN
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 4, LEER ; Tail Whip → similar move
	learnset 9, CONFUSION
	learnset 13, DISARM_VOICE ; Fairy Wind → similar move
	learnset 17, STOMP
	learnset 21, HEALINGLIGHT ; Heal Pulse → similar move
	learnset 25, PSYBEAM
	learnset 29, TAKE_DOWN
	learnset 33, DAZZLINGLEAM
	learnset 37, AGILITY
	learnset 41, PSYCHIC_M
	learnset 45, EXTREMESPEED ; Bounce → new move
	learnset 49, MOONBLAST ; Healing Wish → new move

	evos_attacks SlowpokePlain
	evo_data EVOLVE_TRADE, KINGS_ROCK, SLOWKING, PLAIN_FORM
	evo_data EVOLVE_LEVEL, 37, SLOWBRO, PLAIN_FORM
	learnset 1, CURSE
	learnset 1, TACKLE
	learnset 3, GROWL
	learnset 6, WATER_GUN
	learnset 9, YAWN
	learnset 12, CONFUSION
	learnset 15, DISABLE
	learnset 18, WATER_PULSE
	learnset 21, HEADBUTT
	learnset 24, ZEN_HEADBUTT
	learnset 27, AMNESIA
	learnset 36, PSYCHIC_M
	learnset 42, RAIN_DANCE
	evos_attacks SlowpokeGalarian
	evo_data EVOLVE_TRADE, KINGS_ROCK, SLOWKING, GALARIAN_FORM
	evo_data EVOLVE_LEVEL, 37, SLOWBRO, GALARIAN_FORM
	learnset 1, CURSE
	learnset 1, TACKLE
	learnset 5, GROWL
	learnset 9, ACID
	learnset 14, CONFUSION
	learnset 19, DISABLE
	learnset 23, HEADBUTT
	learnset 28, WATER_PULSE
	learnset 32, ZEN_HEADBUTT
	learnset 36, SAFEGUARD ; Slack Off → egg move
	learnset 41, AMNESIA
	learnset 45, PSYCHIC_M
	learnset 49, RAIN_DANCE
	learnset 54, BELLY_DRUM ; Psych Up → egg move
	learnset 58, RECOVER ; Heal Pulse → similar move

	evos_attacks SlowbroPlain
	learnset 1, CURSE
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 1, WATER_GUN
	learnset 9, YAWN
	learnset 12, CONFUSION
	learnset 15, DISABLE
	learnset 18, WATER_PULSE
	learnset 21, HEADBUTT
	learnset 24, ZEN_HEADBUTT
	learnset 27, AMNESIA
	learnset 36, PSYCHIC_M
	learnset 46, RAIN_DANCE
	evos_attacks SlowbroGalarian
	learnset 1, GUNK_SHOT ; Shell Side Arm → similar move ; evolution move
	learnset 1, CURSE
	learnset 1, TACKLE
	learnset 5, GROWL
	learnset 9, ACID
	learnset 14, CONFUSION
	learnset 19, DISABLE
	learnset 23, HEADBUTT
	learnset 28, WATER_PULSE
	learnset 32, ZEN_HEADBUTT
	learnset 36, SAFEGUARD ; Slack Off → egg move
	learnset 43, AMNESIA
	learnset 49, PSYCHIC_M
	learnset 55, RAIN_DANCE
	learnset 62, BELLY_DRUM ; Psych Up → egg move
	learnset 68, RECOVER ; Heal Pulse → similar move

	evos_attacks Magnemite
	evo_data EVOLVE_LEVEL, 30, MAGNETON
	learnset 1, TACKLE
	learnset 1, THUNDERSHOCK
	learnset 4, SUPERSONIC
	learnset 8, THUNDER_WAVE
	learnset 16, GYRO_BALL
	learnset 20, SPARK
	learnset 24, SCREECH
	learnset 32, FLASH_CANNON
	learnset 44, LIGHT_SCREEN
	evos_attacks Magneton
	evo_data EVOLVE_ITEM, THUNDERSTONE, MAGNEZONE
	evo_data EVOLVE_LOCATION, MAGNET_TUNNEL, MAGNEZONE
	evo_data EVOLVE_LOCATION, DIM_CAVE, MAGNEZONE
	learnset 0, TRI_ATTACK
	learnset 1, SUPERSONIC
	learnset 1, TACKLE
	learnset 1, THUNDERSHOCK
	learnset 1, THUNDER_WAVE
	learnset 16, GYRO_BALL
	learnset 20, SPARK
	learnset 24, SCREECH
	learnset 34, FLASH_CANNON
	learnset 52, LIGHT_SCREEN
	evos_attacks FarfetchDPlain
	evo_data EVOLVE_MENTAL, 36, MADAME, PLAIN_FORM
	learnset 1, PECK
	learnset 5, LEER
	learnset 20, AERIAL_ACE
	learnset 30, KNOCK_OFF
	learnset 35, FALSE_SWIPE
	learnset 40, SLASH
	learnset 45, SWORDS_DANCE
	learnset 50, AIR_SLASH
	learnset 60, AGILITY
	learnset 65, BRAVE_BIRD
	evos_attacks FarfetchDGalarian
	evo_data EVOLVE_CRIT, TR_ANYTIME, SIRFETCH_D, PLAIN_FORM
	learnset 1, PECK
	learnset 1, MUD_SLAP ; Sand Attack → similar move
	learnset 5, LEER
	learnset 10, QUICK_ATTACK ; Fury Cutter → egg move
if DEF(FAITHFUL)
	learnset 15, BRICK_BREAK
else
	learnset 15, REVERSAL ; Rock Smash → TM move
endc
	learnset 20, FEINT_ATTACK ; Brutal Swing → similar move
	learnset 25, PROTECT ; Detect → similar move
	learnset 30, KNOCK_OFF
	learnset 35, STEEL_WING ; Defog → TM move
if DEF(FAITHFUL)
	learnset 40, NIGHT_SLASH ; Brick Break → egg move
else
	learnset 40, BRICK_BREAK
endc
	learnset 45, SWORDS_DANCE
	learnset 50, BODY_SLAM ; Slam → TR move
	learnset 55, POISON_JAB ; Leaf Blade → TR move
	learnset 60, CLOSE_COMBAT ; Final Gambit → TR move
	learnset 65, BRAVE_BIRD

	evos_attacks Doduo
	evo_data EVOLVE_LEVEL, 31, DODRIO
	learnset 1, GROWL
	learnset 1, PECK
	learnset 5, QUICK_ATTACK
	learnset 23, AGILITY
	learnset 33, SWORDS_DANCE
	learnset 36, DRILL_PECK
	learnset 43, THRASH
	evos_attacks Dodrio
	learnset 0, TRI_ATTACK
	learnset 1, GROWL
	learnset 1, PECK
	learnset 1, QUICK_ATTACK
	learnset 23, AGILITY
	learnset 34, SWORDS_DANCE
	learnset 38, DRILL_PECK
	learnset 50, THRASH
	evos_attacks Seel
	evo_data EVOLVE_LEVEL, 34, DEWGONG
	learnset 1, HEADBUTT
	learnset 3, GROWL
	learnset 7, CHARM
	learnset 11, ICY_WIND
	learnset 13, ENCORE
	learnset 17, ICE_SHARD
	learnset 21, REST
	learnset 27, AURORA_BEAM
	learnset 31, AQUA_JET
	learnset 37, TAKE_DOWN
	learnset 43, AQUA_TAIL
	learnset 47, ICE_BEAM
	learnset 51, SAFEGUARD
	evos_attacks Dewgong
	learnset 1, GROWL
	learnset 1, HEADBUTT
	learnset 1, ICY_WIND
	learnset 13, ENCORE
	learnset 17, ICE_SHARD
	learnset 21, REST
	learnset 27, AURORA_BEAM
	learnset 31, AQUA_JET
	learnset 39, TAKE_DOWN
	learnset 49, AQUA_TAIL
	learnset 55, ICE_BEAM
	learnset 61, SAFEGUARD
	evos_attacks GrimerPlain
	evo_data EVOLVE_LEVEL, 38, MUK, PLAIN_FORM
	learnset 7, MUD_SLAP
	learnset 12, DISABLE
	learnset 21, MINIMIZE
	learnset 26, TOXIC
	learnset 29, SLUDGE_BOMB
	learnset 37, SCREECH
	learnset 40, GUNK_SHOT
	evos_attacks GrimerAlolan
	evo_data EVOLVE_LEVEL, 38, MUK, ALOLAN_FORM
	learnset 1, TACKLE ; Pound → similar move
	learnset 1, ACID ; Poison Gas → new move
	learnset 4, DEFENSE_CURL ; Harden → similar move
	learnset 7, BITE
	learnset 12, DISABLE
	learnset 15, VENOSHOCK ; Acid Spray → tutor move
	learnset 18, HAZE ; Poison Fang → egg move
	learnset 21, MINIMIZE
	learnset 26, FEINT_ATTACK ; Fling → new move
	learnset 29, KNOCK_OFF
	learnset 32, CRUNCH
	learnset 37, SCREECH
	learnset 40, GUNK_SHOT
	learnset 43, PAIN_SPLIT ; Acid Armor → HGSS tutor move
	learnset 46, TOXIC_SPIKES ; Belch → SV TM move

	evos_attacks MukPlain
	learnset 1, MUD_SLAP
	learnset 12, DISABLE
	learnset 21, MINIMIZE
	learnset 26, TOXIC
	learnset 29, SLUDGE_BOMB
	learnset 37, SCREECH
	learnset 40, GUNK_SHOT
	evos_attacks MukAlolan
	learnset 1, MOONBLAST ; LGPE move
	learnset 1, TACKLE ; Pound → similar move
	learnset 1, ACID ; Poison Gas → new move
	learnset 4, DEFENSE_CURL ; Harden → similar move
	learnset 7, BITE
	learnset 12, DISABLE
	learnset 15, VENOSHOCK ; Acid Spray → tutor move
	learnset 18, HAZE ; Poison Fang → egg move
	learnset 21, MINIMIZE
	learnset 26, FEINT_ATTACK ; Fling → new move
	learnset 29, KNOCK_OFF
	learnset 32, CRUNCH
	learnset 37, SCREECH
	learnset 40, GUNK_SHOT
	learnset 46, PAIN_SPLIT ; Acid Armor → HGSS tutor move
	learnset 52, TOXIC_SPIKES ; Belch → SV TM move

	evos_attacks Shellder
	evo_data EVOLVE_ITEM, WATER_STONE, CLOYSTER
	learnset 1, TACKLE
	learnset 1, WATER_GUN
	learnset 8, ICE_SHARD
	learnset 12, LEER
	learnset 20, SUPERSONIC
	learnset 24, AURORA_BEAM
	learnset 28, PROTECT
	learnset 40, ICE_BEAM
	learnset 44, SHELL_SMASH
	learnset 48, HYDRO_PUMP
	evos_attacks Cloyster
	learnset 0, ICICLE_SPEAR
	learnset 1, AURORA_BEAM
	learnset 1, HYDRO_PUMP
	learnset 1, ICE_BEAM
	learnset 1, ICE_SHARD
	learnset 1, ICICLE_CRASH
	learnset 1, LEER
	learnset 1, PROTECT
	learnset 1, SHELL_SMASH
	learnset 1, SPIKES
	learnset 1, SUPERSONIC
	learnset 1, TACKLE
	learnset 1, TOXIC_SPIKES
	learnset 1, WATER_GUN
	evos_attacks Gastly
	evo_data EVOLVE_LEVEL, 25, HAUNTER
	learnset 1, CONFUSE_RAY
	learnset 1, LICK
	learnset 4, HYPNOSIS
	learnset 8, MEAN_LOOK
	learnset 20, CURSE
	learnset 24, HEX
	learnset 28, NIGHT_SHADE
	learnset 32, SUCKER_PUNCH
	learnset 36, DARK_PULSE
	learnset 40, SHADOW_BALL
	learnset 44, DESTINY_BOND
	learnset 48, DREAM_EATER
	evos_attacks Haunter
	evo_data EVOLVE_TRADE, LINKING_CORD, GENGAR
	learnset 1, CONFUSE_RAY
	learnset 1, HYPNOSIS
	learnset 1, LICK
	learnset 1, MEAN_LOOK
	learnset 20, CURSE
	learnset 24, HEX
	learnset 30, NIGHT_SHADE
	learnset 36, SUCKER_PUNCH
	learnset 42, DARK_PULSE
	learnset 48, SHADOW_BALL
	learnset 54, DESTINY_BOND
	learnset 60, DREAM_EATER
	evos_attacks Gengar
	learnset 1, CONFUSE_RAY
	learnset 1, HYPNOSIS
	learnset 1, LICK
	learnset 1, MEAN_LOOK
	learnset 1, PERISH_SONG
	learnset 20, CURSE
	learnset 24, HEX
	learnset 30, NIGHT_SHADE
	learnset 36, SUCKER_PUNCH
	learnset 42, DARK_PULSE
	learnset 48, SHADOW_BALL
	learnset 54, DESTINY_BOND
	learnset 60, DREAM_EATER
	evos_attacks Onix
	evo_data EVOLVE_TRADE, METAL_COAT, STEELIX
	learnset 1, ROCK_THROW
	learnset 1, TACKLE
	learnset 12, DRAGONBREATH
	learnset 16, CURSE
	learnset 20, ROCK_SLIDE
	learnset 24, SCREECH
	learnset 32, STEALTH_ROCK
	learnset 40, SANDSTORM
	learnset 44, DIG
	learnset 48, IRON_TAIL
	learnset 52, STONE_EDGE
	learnset 56, DOUBLE_EDGE
	evos_attacks Drowzee
	evo_data EVOLVE_LEVEL, 26, HYPNO
	learnset 1, HYPNOSIS
	learnset 5, DISABLE
	learnset 9, CONFUSION
	learnset 13, HEADBUTT
	learnset 21, PSYBEAM
	learnset 29, ZEN_HEADBUTT
	learnset 33, SWAGGER
	learnset 37, PSYCHIC_M
	learnset 41, NASTY_PLOT
	learnset 49, FUTURE_SIGHT
	evos_attacks Hypno
	learnset 1, CONFUSION
	learnset 1, DISABLE
	learnset 1, HYPNOSIS
	learnset 13, HEADBUTT
	learnset 21, PSYBEAM
	learnset 32, ZEN_HEADBUTT
	learnset 37, SWAGGER
	learnset 42, PSYCHIC_M
	learnset 47, NASTY_PLOT
	learnset 56, FUTURE_SIGHT
	evos_attacks Krabby
	evo_data EVOLVE_LEVEL, 28, KINGLER
	learnset 1, LEER
	learnset 1, WATER_GUN
	learnset 8, METAL_CLAW
	learnset 16, PROTECT
	learnset 20, BUBBLE_BEAM
	learnset 24, STOMP
	learnset 40, SWORDS_DANCE
	evos_attacks Kingler
	learnset 1, LEER
	learnset 1, METAL_CLAW
	learnset 1, WATER_GUN
	learnset 16, PROTECT
	learnset 20, BUBBLE_BEAM
	learnset 24, STOMP
	learnset 48, SWORDS_DANCE
	evos_attacks VoltorbPlain
	evo_data EVOLVE_LEVEL, 30, ELECTRODE
	learnset 1, TACKLE
	learnset 4, THUNDERSHOCK
	learnset 9, SPARK
	learnset 11, ROLLOUT
	learnset 13, SCREECH
	learnset 20, SWIFT
	learnset 29, LIGHT_SCREEN
	learnset 41, EXPLOSION
	learnset 46, GYRO_BALL
	learnset 50, MIRROR_COAT
	evos_attacks ElectrodePlain
	learnset 1, TACKLE
	learnset 1, THUNDERSHOCK
	learnset 9, SPARK
	learnset 11, ROLLOUT
	learnset 13, SCREECH
	learnset 20, SWIFT
	learnset 29, LIGHT_SCREEN
	learnset 47, EXPLOSION
	learnset 54, GYRO_BALL
	learnset 58, MIRROR_COAT
	evos_attacks VoltorbHisuian
	evo_data EVOLVE_ITEM, LEAF_STONE, ELECTRODE, HISUIAN_FORM
	learnset 1, TACKLE
	learnset 1, THUNDERSHOCK ; LGPE move
	learnset 1, ABSORB ; new move
	learnset 4, SONIC_BOOM
	learnset 6, AGILITY ; Eerie Impulse → event move
	learnset 9, SPARK
	learnset 11, ROLLOUT
	learnset 13, SCREECH
	learnset 16, THUNDER_WAVE ; Charge Beam → TM move
	learnset 20, SWIFT
	learnset 22, THUNDERBOLT ; Electro Ball → TM move
	learnset 26, ENERGY_BALL
	learnset 29, LIGHT_SCREEN
	learnset 34, EXPLOSION ; Magnet Rise → Explosion
	learnset 37, THUNDER ; Discharge → TM move
	learnset 41, SOLAR_BEAM ; Chloroblast → TM move
	learnset 46, GYRO_BALL
	learnset 48, MIRROR_COAT

	evos_attacks ElectrodeHisuian
	learnset 1, TACKLE
	learnset 1, THUNDERSHOCK ; LGPE move
	learnset 1, ABSORB ; new move
	learnset 4, SONIC_BOOM
	learnset 6, AGILITY ; Eerie Impulse → event move
	learnset 9, SPARK
	learnset 11, ROLLOUT
	learnset 13, SCREECH
	learnset 16, THUNDER_WAVE ; Charge Beam → TM move
	learnset 20, SWIFT
	learnset 22, THUNDERBOLT ; Electro Ball → TM move
	learnset 26, ENERGY_BALL
	learnset 29, LIGHT_SCREEN
	learnset 36, EXPLOSION ; Magnet Rise → Explosion
	learnset 41, THUNDER ; Discharge → TM move
	learnset 47, SOLAR_BEAM ; Chloroblast → TM move
	learnset 54, GYRO_BALL
	learnset 58, MIRROR_COAT

	evos_attacks Exeggcute
	evo_data EVOLVE_ITEM, LEAF_STONE, EXEGGUTOR, PLAIN_FORM
	evo_data EVOLVE_ITEM, ODD_SOUVENIR, EXEGGUTOR, ALOLAN_FORM
	learnset 1, ABSORB
	learnset 1, HYPNOSIS
	learnset 5, REFLECT
	learnset 10, LEECH_SEED
	learnset 15, MEGA_DRAIN
	learnset 20, CONFUSION
	learnset 35, GIGA_DRAIN
	learnset 40, EXTRASENSORY
	learnset 55, SOLAR_BEAM
	evos_attacks ExeggutorPlain
	learnset 0, STOMP
	learnset 1, ABSORB
	learnset 1, CONFUSION
	learnset 1, EXTRASENSORY
	learnset 1, GIGA_DRAIN
	learnset 1, HYPNOSIS
	learnset 1, LEECH_SEED
	learnset 1, MEGA_DRAIN
	learnset 1, REFLECT
	learnset 1, SEED_BOMB
	learnset 1, SOLAR_BEAM
	evos_attacks ExeggutorAlolan
	learnset 1, TACKLE ; Barrage → new move
	learnset 1, HYPNOSIS
	learnset 1, CONFUSION
	learnset 1, DRAGON_PULSE ; evolution move
	learnset 17, DRAGON_RAGE ; Psyshock → new move
	learnset 27, ZEN_HEADBUTT ; Egg Bomb → tutor move
	learnset 37, POWER_WHIP ; Wood Hammer → new move
	learnset 47, OUTRAGE ; Leaf Storm → S/M TM move

	evos_attacks Cubone
	evo_data EVOLVE_LEVEL, 28, MAROWAK, PLAIN_FORM
	evo_data EVOLVE_ITEM, ODD_SOUVENIR, MAROWAK, ALOLAN_FORM
	learnset 1, GROWL
	learnset 3, TACKLE ; Tail Whip → new move
	learnset 7, MUD_SLAP ; Bone Club → TM move
	learnset 11, HEADBUTT
	learnset 13, LEER
	learnset 17, BULK_UP
	learnset 21, EARTHQUAKE
	learnset 23, RAGE
	learnset 27, LOW_KICK ; False Swipe → HGSS tutor move
	learnset 31, FALSE_SWIPE ; Thrash → False Swipe
	learnset 33, THRASH ; Fling → Thrash
	learnset 37, MAGNITUDE ; Stomping Tantrum → new move
	learnset 41, ROCK_TOMB ; Endeavor → TM move
	learnset 43, DOUBLE_EDGE
	learnset 47, REVERSAL ; Retaliate → new move
	learnset 51, OUTRAGE ; Bone Rush → HGSS tutor move

	evos_attacks MarowakPlain
	learnset 1, SWORDS_DANCE ; evolution move
	learnset 1, GROWL
	learnset 3, TACKLE ; Tail Whip → new move
	learnset 7, MUD_SLAP ; Bone Club → TM move
	learnset 11, HEADBUTT
	learnset 13, LEER
	learnset 17, BULK_UP
	learnset 21, EARTHQUAKE
	learnset 23, RAGE
	learnset 27, LOW_KICK ; False Swipe → HGSS tutor move
	learnset 33, THRASH
	learnset 37, KNOCK_OFF ; Fling → TM move
	learnset 43, MAGNITUDE ; Stomping Tantrum → new move
	learnset 49, ROCK_TOMB ; Endeavor → TM move
	learnset 53, DOUBLE_EDGE
	learnset 59, REVERSAL ; Retaliate → new move
	learnset 65, OUTRAGE ; Bone Rush → HGSS tutor move

	evos_attacks MarowakAlolan
	learnset 1, SWORDS_DANCE ; evolution move
	learnset 1, GROWL
	learnset 3, TACKLE ; Tail Whip → new move
	learnset 7, ASTONISH ; Bone Club → new move
	learnset 11, FIRE_SPIN ; Flame Wheel → LGPE move
	learnset 13, LEER
	learnset 17, HEX
	learnset 21, EARTHQUAKE
	learnset 23, WILL_O_WISP
	learnset 27, SHADOW_CLAW ; Shadow Bone → similar move
	learnset 33, THRASH
	learnset 37, KNOCK_OFF ; Fling → TM move
	learnset 43, ACROBATICS ; Stomping Tantrum → new move
	learnset 49, ROCK_TOMB ; Endeavor → TM move
	learnset 53, FLARE_BLITZ
	learnset 59, PAIN_SPLIT ; Retaliate → S/M tutor move
	learnset 65, OUTRAGE ; Bone Rush → HGSS tutor move

	evos_attacks Hitmonlee
	learnset 1, FAKE_OUT
	learnset 1, TACKLE
	learnset 4, DOUBLE_KICK
	learnset 8, LOW_KICK
	learnset 12, ENDURE
	learnset 16, SUCKER_PUNCH
	learnset 21, FEINT
	learnset 32, BRICK_BREAK
	learnset 36, CLOSE_COMBAT
	learnset 40, REVERSAL

	evos_attacks Hitmonchan
	learnset 0, DRAIN_PUNCH
	learnset 1, FAKE_OUT
	learnset 1, TACKLE
	learnset 4, MACH_PUNCH
	learnset 7, FOCUS_ENERGY
	learnset 16, BULLET_PUNCH
	learnset 21, FEINT
	learnset 24, FIRE_PUNCH
	learnset 24, ICE_PUNCH
	learnset 24, THUNDERPUNCH
	learnset 28, AGILITY
	learnset 36, CLOSE_COMBAT
	learnset 40, COUNTER
	evos_attacks Lickitung
	evo_data EVOLVE_MOVE, ROLLOUT, LICKILICKY
	learnset 1, DEFENSE_CURL
	learnset 1, LICK
	learnset 6, ROLLOUT
	learnset 12, SUPERSONIC
	learnset 18, WRAP
	learnset 24, DISABLE
	learnset 30, STOMP
	learnset 36, KNOCK_OFF
	learnset 42, SCREECH
	learnset 54, POWER_WHIP
	learnset 60, BELLY_DRUM
	evos_attacks Koffing
	evo_data EVOLVE_TRADE, CHARCOAL, WEEZING, GALARIAN_FORM
	evo_data EVOLVE_LEVEL, 35, WEEZING, PLAIN_FORM
	learnset 1, TACKLE
	learnset 8, SMOKESCREEN
	learnset 24, HAZE
	learnset 32, SLUDGE_BOMB
	learnset 36, TOXIC
	learnset 44, EXPLOSION
	learnset 52, DESTINY_BOND
	evos_attacks WeezingPlain
	learnset 1, SMOKESCREEN
	learnset 1, TACKLE
	learnset 24, HAZE
	learnset 32, SLUDGE_BOMB
	learnset 38, TOXIC
	learnset 50, EXPLOSION
	learnset 62, DESTINY_BOND
	evos_attacks WeezingGalarian
	learnset 1, SAFEGUARD ; evolution move
	learnset 1, TACKLE
	learnset 4, GUST ; Smog → new move
	learnset 7, SMOKESCREEN
	learnset 12, ENDURE ; Assurance → TM move
	learnset 15, WILL_O_WISP ; Clear Smog → TM move
	learnset 18, SCREECH ; Sludge → Sw/Sh TM move
	learnset 23, RAGE ; Self-Destruct → RBY TM move
	learnset 26, HAZE ; Aromatherapy → Kantonian move
	learnset 29, GYRO_BALL
	learnset 34, PLAY_ROUGH ; Sludge Bomb → Sw/Sh TR move
	learnset 40, EXPLOSION
	learnset 46, DESTINY_BOND
	learnset 51, PAIN_SPLIT ; Belch → HGSS tutor move
	learnset 57, MOONBLAST ; Memento → new move

	evos_attacks Rhyhorn
	evo_data EVOLVE_LEVEL, 42, RHYDON
	learnset 1, TACKLE
	learnset 10, BULLDOZE
	learnset 15, HORN_ATTACK
	learnset 20, SCARY_FACE
	learnset 25, STOMP
	learnset 30, ROCK_BLAST
	learnset 40, TAKE_DOWN
	learnset 45, EARTHQUAKE
	learnset 50, STONE_EDGE
	learnset 55, MEGAHORN
	evos_attacks Rhydon
	evo_data EVOLVE_TRADE, PROTECTOR, RHYPERIOR
	learnset 1, BULLDOZE
	learnset 1, TACKLE
	learnset 15, HORN_ATTACK
	learnset 20, SCARY_FACE
	learnset 25, STOMP
	learnset 30, ROCK_BLAST
	learnset 40, TAKE_DOWN
	learnset 47, EARTHQUAKE
	learnset 54, STONE_EDGE
	learnset 61, MEGAHORN
	evos_attacks Chansey
	evo_data EVOLVE_HAPPINESS, TR_ANYTIME, BLISSEY
	learnset 1, CHARM
	learnset 1, DEFENSE_CURL
	learnset 1, DISARM_VOICE
	learnset 1, SWEET_KISS
	learnset 16, SING
	learnset 24, TAKE_DOWN
	learnset 36, LIGHT_SCREEN
	learnset 40, DOUBLE_EDGE
	evos_attacks Tangela
	evo_data EVOLVE_MOVE, ANCIENTPOWER, TANGROWTH
	learnset 1, ABSORB
	learnset 4, STUN_SPORE
	learnset 8, GROWTH
	learnset 12, MEGA_DRAIN
	learnset 16, VINE_WHIP
	learnset 20, POISONPOWDER
	learnset 24, ANCIENTPOWER
	learnset 28, KNOCK_OFF
	learnset 32, GIGA_DRAIN
	learnset 36, SLEEP_POWDER
	learnset 48, POWER_WHIP
	evos_attacks Kangaskhan
	learnset 4, GROWL
	learnset 12, BITE
	learnset 16, STOMP
	learnset 24, HEADBUTT
	learnset 28, SUCKER_PUNCH
	learnset 36, CRUNCH
	learnset 40, ENDURE
	learnset 44, REVERSAL
	learnset 48, OUTRAGE
	evos_attacks Horsea
	evo_data EVOLVE_LEVEL, 32, SEADRA
	learnset 1, LEER
	learnset 1, WATER_GUN
	learnset 5, SMOKESCREEN
	learnset 20, DRAGONBREATH
	learnset 25, BUBBLE_BEAM
	learnset 30, AGILITY
	learnset 35, WATER_PULSE
	learnset 40, DRAGON_PULSE
	learnset 45, HYDRO_PUMP
	learnset 50, DRAGON_DANCE
	learnset 55, RAIN_DANCE
	evos_attacks Seadra
	evo_data EVOLVE_TRADE, DRAGON_SCALE, KINGDRA
	learnset 1, LEER
	learnset 1, SMOKESCREEN
	learnset 1, WATER_GUN
	learnset 20, DRAGONBREATH
	learnset 25, BUBBLE_BEAM
	learnset 30, AGILITY
	learnset 37, WATER_PULSE
	learnset 44, DRAGON_PULSE
	learnset 51, HYDRO_PUMP
	learnset 58, DRAGON_DANCE
	learnset 65, RAIN_DANCE
	evos_attacks Goldeen
	evo_data EVOLVE_LEVEL, 33, SEAKING
	learnset 1, PECK
	learnset 5, SUPERSONIC
	learnset 10, WATER_PULSE
	learnset 15, HORN_ATTACK
	learnset 20, AGILITY
	learnset 35, WATERFALL
	learnset 45, MEGAHORN
	evos_attacks Seaking
	learnset 1, PECK
	learnset 1, SUPERSONIC
	learnset 1, WATER_PULSE
	learnset 15, HORN_ATTACK
	learnset 20, AGILITY
	learnset 37, WATERFALL
	learnset 51, MEGAHORN
	evos_attacks Staryu
	evo_data EVOLVE_ITEM, WATER_STONE, STARMIE
	learnset 1, TACKLE
	learnset 4, WATER_GUN
	learnset 8, CONFUSE_RAY
	learnset 12, RAPID_SPIN
	learnset 16, MINIMIZE
	learnset 20, SWIFT
	learnset 24, PSYBEAM
	learnset 32, LIGHT_SCREEN
	learnset 36, POWER_GEM
	learnset 40, PSYCHIC_M
	learnset 48, RECOVER
	learnset 56, HYDRO_PUMP
	evos_attacks Starmie
	learnset 1, CONFUSE_RAY
	learnset 1, HYDRO_PUMP
	learnset 1, LIGHT_SCREEN
	learnset 1, MINIMIZE
	learnset 1, POWER_GEM
	learnset 1, PSYBEAM
	learnset 1, PSYCHIC_M
	learnset 1, RAPID_SPIN
	learnset 1, RECOVER
	learnset 1, SWIFT
	learnset 1, TACKLE
	learnset 1, WATER_GUN
	evos_attacks MrMimePlain
	learnset 1, BARRIER
	learnset 1, CONFUSION
	learnset 4, HYPNOSIS ; Copycat → egg move
	learnset 8, CALM_MIND ; Meditate → TM move
	learnset 11, DOUBLE_SLAP
	learnset 13, PROTECT ; Mimic → event move
	learnset 15, METRONOME ; Psywave → RBY TM move
	learnset 18, ENCORE
	learnset 22, LIGHT_SCREEN
	learnset 22, REFLECT
	learnset 25, PSYBEAM
	learnset 29, SUBSTITUTE
	learnset 32, CONFUSE_RAY ; Recycle → egg move
	learnset 36, TRICK
	learnset 39, PSYCHIC_M
	learnset 43, FUTURE_SIGHT ; Role Play → egg move
	learnset 46, BATON_PASS
	learnset 50, SAFEGUARD

	evos_attacks Scyther
	evo_data EVOLVE_TRADE, METAL_COAT, SCIZOR
	evo_data EVOLVE_HOLDING, HARD_STONE, TR_ANYTIME, KLEAVOR
	learnset 1, QUICK_ATTACK
	learnset 1, LEER
	learnset 5, BULK_UP
	learnset 9, PURSUIT
	learnset 13, FALSE_SWIPE
	learnset 17, AGILITY
	learnset 21, WING_ATTACK
	learnset 25, BUG_BITE ; Fury Cutter → similar move
	learnset 29, FOCUS_ENERGY
	learnset 29, SLASH
	learnset 33, GLARE ; Razor Wind → new move
	learnset 37, DOUBLE_TEAM
	learnset 41, X_SCISSOR
	learnset 45, NIGHT_SLASH
	learnset 49, CLOSE_COMBAT ; Double Hit → SV TM move
	learnset 50, AIR_SLASH
	learnset 57, SWORDS_DANCE

	evos_attacks Jynx
	learnset 1, PETAL_DANCE ; event move
	learnset 1, TACKLE ; Pound → similar move
	learnset 1, LICK
	learnset 1, CONFUSION ; Smoochum move
	learnset 1, SWEET_KISS ; Smoochum move
	learnset 5, SING ; Lovely Kiss → Smoochum move
	learnset 8, SCREECH ; Lovely Kiss → LGPE move
	learnset 11, ICY_WIND ; Powder Snow → TM move
	learnset 15, DOUBLE_SLAP
	learnset 18, ICE_PUNCH
	learnset 21, METRONOME ; Heart Stamp → RBY TM move
	learnset 25, MEAN_LOOK
	learnset 28, DRAINING_KISS ; Fake Tears → Drain Kiss
	learnset 33, PSYBEAM ; Wake-Up Slap → new move
	learnset 39, AVALANCHE
	learnset 44, BODY_SLAM
	learnset 49, NASTY_PLOT ; Wring Out → egg move
	learnset 55, PERISH_SONG
	learnset 60, BLIZZARD

	evos_attacks Electabuzz
	evo_data EVOLVE_TRADE, ELECTIRIZER, ELECTIVIRE
	learnset 1, LEER
	learnset 1, QUICK_ATTACK
	learnset 1, THUNDERSHOCK
	learnset 12, SWIFT
	learnset 20, THUNDER_WAVE
	learnset 24, SCREECH
	learnset 28, THUNDERPUNCH
	learnset 40, LOW_KICK
	learnset 46, THUNDERBOLT
	learnset 52, LIGHT_SCREEN
	learnset 58, THUNDER
	learnset 64, GIGA_IMPACT
	evos_attacks Magmar
	evo_data EVOLVE_TRADE, MAGMARIZER, MAGMORTAR
	learnset 1, EMBER
	learnset 1, LEER
	learnset 1, SMOKESCREEN
	learnset 20, CONFUSE_RAY
	learnset 24, SCARY_FACE
	learnset 28, FIRE_PUNCH
	learnset 40, LOW_KICK
	learnset 46, FLAMETHROWER
	learnset 52, SUNNY_DAY
	learnset 58, FIRE_BLAST
	learnset 64, HYPER_BEAM
	evos_attacks Pinsir
	learnset 12, SEISMIC_TOSS
	learnset 16, BUG_BITE
	learnset 32, X_SCISSOR
	learnset 40, SWORDS_DANCE
	evos_attacks TaurosPlain
	learnset 1, TACKLE
	learnset 20, HORN_ATTACK
	learnset 25, SCARY_FACE
	learnset 30, ZEN_HEADBUTT
	learnset 40, REST
	learnset 45, SWAGGER
	learnset 50, THRASH
	learnset 55, DOUBLE_EDGE
	learnset 60, GIGA_IMPACT
	evos_attacks TaurosPaldean
	learnset 1, TACKLE
	learnset 3, LEER ; Tail Whip → similar move
	learnset 5, RAGE
	learnset 8, HEADBUTT
	learnset 11, SCARY_FACE
	learnset 15, PURSUIT
	learnset 19, REST
	learnset 24, DOUBLE_KICK
	learnset 29, BULK_UP ; Work Up → LGPE move
	learnset 35, TAKE_DOWN
	learnset 41, ZEN_HEADBUTT
	learnset 48, SWAGGER
	learnset 55, THRASH
	learnset 63, DOUBLE_EDGE
	learnset 71, CLOSE_COMBAT
	learnset 80, OUTRAGE ; HGSS tutor move

	evos_attacks TaurosPaldeanFire
	learnset 1, TACKLE
	learnset 3, LEER ; Tail Whip → similar move
	learnset 5, RAGE
	learnset 8, HEADBUTT
	learnset 11, SCARY_FACE
	learnset 15, FLAME_CHARGE
	learnset 19, REST
	learnset 24, DOUBLE_KICK
	learnset 29, BULK_UP ; Work Up → LGPE move
	learnset 35, TAKE_DOWN
	learnset 41, ZEN_HEADBUTT
	learnset 48, SWAGGER
	learnset 55, THRASH
	learnset 63, FLARE_BLITZ
	learnset 71, CLOSE_COMBAT
	learnset 80, OUTRAGE ; HGSS tutor move

	evos_attacks TaurosPaldeanWater
	learnset 1, TACKLE
	learnset 3, LEER ; Tail Whip → similar move
	learnset 5, RAGE
	learnset 8, HEADBUTT
	learnset 11, SCARY_FACE
	learnset 15, AQUA_JET
	learnset 19, REST
	learnset 24, DOUBLE_KICK
	learnset 29, BULK_UP ; Work Up → LGPE move
	learnset 35, TAKE_DOWN
	learnset 41, ZEN_HEADBUTT
	learnset 48, SWAGGER
	learnset 55, THRASH
	learnset 63, AQUA_TAIL ; Wave Crash → tutor move
	learnset 71, CLOSE_COMBAT
	learnset 80, OUTRAGE ; HGSS tutor move

	evos_attacks Magikarp
	evo_data EVOLVE_LEVEL, 20, GYARADOS, NO_FORM ; preserve pre-evo form
	learnset 1, SPLASH
	learnset 15, TACKLE
	evos_attacks Gyarados
	learnset 0, BITE
	learnset 1, LEER
	learnset 1, SPLASH
	learnset 1, TACKLE
	learnset 16, SCARY_FACE
	learnset 21, WATERFALL
	learnset 24, CRUNCH
	learnset 28, RAIN_DANCE
	learnset 32, AQUA_TAIL
	learnset 36, DRAGON_DANCE
	learnset 40, HYDRO_PUMP
	learnset 44, HURRICANE
	learnset 48, THRASH
	learnset 52, HYPER_BEAM
	evos_attacks Lapras
	learnset 1, GROWL
	learnset 1, WATER_GUN
	learnset 5, SING
	learnset 20, ICE_SHARD
	learnset 25, CONFUSE_RAY
	learnset 30, WATER_PULSE
	learnset 40, BODY_SLAM
	learnset 45, ICE_BEAM
	learnset 50, RAIN_DANCE
	learnset 55, HYDRO_PUMP
	learnset 60, PERISH_SONG
	evos_attacks Ditto
	learnset 1, METRONOME
	evos_attacks Eevee
	evo_data EVOLVE_ITEM, THUNDERSTONE, JOLTEON
	evo_data EVOLVE_ITEM, WATER_STONE, VAPOREON
	evo_data EVOLVE_ITEM, FIRE_STONE, FLAREON
	evo_data EVOLVE_ITEM, SUN_STONE, ESPEON
	evo_data EVOLVE_ITEM, MOON_STONE, UMBREON
	evo_data EVOLVE_ITEM, LEAF_STONE, LEAFEON
	evo_data EVOLVE_ITEM, ICE_STONE, GLACEON
	evo_data EVOLVE_ITEM, SHINY_STONE, SYLVEON
	evo_data EVOLVE_LOCATION, ILEX_FOREST, LEAFEON
	evo_data EVOLVE_LOCATION, ICE_PATH, GLACEON
	evo_data EVOLVE_HAPPINESS, TR_MORNDAY, ESPEON
	evo_data EVOLVE_HAPPINESS, TR_EVENITE, UMBREON
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 10, QUICK_ATTACK
	learnset 20, SWIFT
	learnset 25, BITE
	learnset 35, BATON_PASS
	learnset 40, TAKE_DOWN
	learnset 45, CHARM
	learnset 50, DOUBLE_EDGE
	evos_attacks Vaporeon
	learnset 0, WATER_GUN
	learnset 1, BATON_PASS
	learnset 1, BITE
	learnset 1, CHARM
	learnset 1, DOUBLE_EDGE
	learnset 1, GROWL
	learnset 1, SWIFT
	learnset 1, TACKLE
	learnset 1, TAKE_DOWN
	learnset 10, QUICK_ATTACK
	learnset 20, HAZE
	learnset 25, WATER_PULSE
	learnset 30, AURORA_BEAM
	learnset 50, HYDRO_PUMP
	evos_attacks Jolteon
	learnset 0, THUNDERSHOCK
	learnset 1, BATON_PASS
	learnset 1, BITE
	learnset 1, CHARM
	learnset 1, DOUBLE_EDGE
	learnset 1, GROWL
	learnset 1, SWIFT
	learnset 1, TACKLE
	learnset 1, TAKE_DOWN
	learnset 10, QUICK_ATTACK
	learnset 20, THUNDER_WAVE
	learnset 25, DOUBLE_KICK
	learnset 35, PIN_MISSILE
	learnset 45, AGILITY
	learnset 50, THUNDER
	evos_attacks Flareon
	learnset 0, EMBER
	learnset 1, BATON_PASS
	learnset 1, CHARM
	learnset 1, DOUBLE_EDGE
	learnset 1, GROWL
	learnset 1, SWIFT
	learnset 1, TACKLE
	learnset 1, TAKE_DOWN
	learnset 10, QUICK_ATTACK
	learnset 25, BITE
	learnset 35, FIRE_SPIN
	learnset 45, SCARY_FACE
	learnset 50, FLARE_BLITZ
	evos_attacks Porygon
	evo_data EVOLVE_TRADE, UPGRADE, PORYGON2
	learnset 1, CONVERSION
	learnset 1, TACKLE
	learnset 15, THUNDERSHOCK
	learnset 20, PSYBEAM
	learnset 30, AGILITY
	learnset 35, RECOVER
	learnset 45, TRI_ATTACK
	learnset 50, DOUBLE_EDGE
	evos_attacks Omanyte
	evo_data EVOLVE_LEVEL, 40, OMASTAR
	learnset 5, ROLLOUT
	learnset 15, WATER_GUN
	learnset 20, LEER
	learnset 30, ANCIENTPOWER
	learnset 41, PROTECT
	learnset 45, ROCK_BLAST
	learnset 55, SHELL_SMASH
	learnset 60, HYDRO_PUMP
	evos_attacks Omastar
	learnset 0, CRUNCH
	learnset 1, ROLLOUT
	learnset 15, WATER_GUN
	learnset 20, LEER
	learnset 30, ANCIENTPOWER
	learnset 43, PROTECT
	learnset 49, ROCK_BLAST
	learnset 63, SHELL_SMASH
	learnset 70, HYDRO_PUMP
	evos_attacks Kabuto
	evo_data EVOLVE_LEVEL, 40, KABUTOPS
	learnset 1, ABSORB
	learnset 5, SCRATCH
	learnset 15, AQUA_JET
	learnset 20, LEER
	learnset 30, ANCIENTPOWER
	learnset 41, PROTECT
	learnset 45, LEECH_LIFE
	learnset 60, STONE_EDGE
	evos_attacks Kabutops
	learnset 0, SLASH
	learnset 1, ABSORB
	learnset 1, NIGHT_SLASH
	learnset 1, SCRATCH
	learnset 15, AQUA_JET
	learnset 20, LEER
	learnset 30, ANCIENTPOWER
	learnset 43, PROTECT
	learnset 49, LEECH_LIFE
	learnset 70, STONE_EDGE
	evos_attacks Aerodactyl
	learnset 1, DRAGON_RAGE ; RBY TM move
	learnset 1, DRAGONBREATH ; GSC TM move
	learnset 1, WING_ATTACK
	learnset 1, SUPERSONIC
	learnset 1, BITE
	learnset 1, SCARY_FACE
	learnset 9, ROAR
	learnset 13, ROCK_THROW ; LGPE move
	learnset 17, AGILITY
	learnset 25, ANCIENTPOWER
	learnset 33, CRUNCH
	learnset 41, TAKE_DOWN
	learnset 49, BRAVE_BIRD ; Sky Drop → new move
	learnset 57, IRON_HEAD
	learnset 65, HYPER_BEAM
	learnset 73, ROCK_SLIDE
	learnset 81, GIGA_IMPACT

	evos_attacks Snorlax
	learnset 1, TACKLE
	learnset 4, DEFENSE_CURL
	learnset 9, AMNESIA
	learnset 12, LICK
	learnset 17, RAGE ; Chip Away → RBY TM move
	learnset 20, YAWN ; Yawn
	learnset 25, BODY_SLAM
	learnset 28, REST
	learnset 33, SLEEP_TALK
	learnset 36, ROLLOUT
	learnset 41, OUTRAGE ; Block → HGSS tutor move
	learnset 44, BELLY_DRUM
	learnset 49, CRUNCH
	learnset 50, CLOSE_COMBAT ; Heavy Slam → new move
	learnset 57, GIGA_IMPACT

	evos_attacks ArticunoPlain
	learnset 1, GUST
	learnset 1, ICY_WIND ; Powder Snow → similar move
	learnset 1, LEER ; LGPE move
	learnset 8, ICE_SHARD ; Mist → Ice Shard
	learnset 15, SAFEGUARD ; Ice Shard → new move
	learnset 22, EXTRASENSORY ; Mind Reader → event move
	learnset 29, ANCIENTPOWER
	learnset 36, AGILITY
	learnset 43, ICE_BEAM
	learnset 50, AIR_SLASH ; Reflect → new move
	learnset 57, HAIL
	learnset 64, TAILWIND ; Tailwind
	learnset 71, BLIZZARD
	learnset 78, BRAVE_BIRD ; Sheer Cold → new move
	learnset 85, ROOST
	learnset 92, HURRICANE
	learnset 99, HURRICANE ; new move

	evos_attacks ArticunoGalarian
	learnset 1, GUST
	learnset 1, CONFUSION
	learnset 1, LEER ; LGPE move
	learnset 8, SAFEGUARD ; Psycho Shift → new move
	learnset 15, HYPNOSIS
	learnset 22, EXTRASENSORY ; Mind Reader → event move
	learnset 29, ANCIENTPOWER
	learnset 36, AGILITY
	learnset 43, PSYCHIC_M ; Freezing Glare → TM move
	learnset 50, AIR_SLASH ; Reflect → new move
	learnset 57, DREAM_EATER
	learnset 64, TAILWIND ; Tailwind
	learnset 71, FUTURE_SIGHT
	learnset 78, BRAVE_BIRD ; Sheer Cold → TR move
	learnset 85, RECOVER
	learnset 92, HURRICANE
	learnset 99, HURRICANE ; new move

	evos_attacks ZapdosPlain
	learnset 1, PECK
	learnset 1, THUNDERSHOCK
	learnset 1, LEER ; LGPE move
	learnset 8, THUNDER_WAVE
	learnset 15, PROTECT ; Detect → similar move
	learnset 22, EXTRASENSORY ; Pluck → event move
	learnset 29, ANCIENTPOWER
	learnset 36, AGILITY ; Charge → Agility
	learnset 43, THUNDERBOLT ; Agility → TM move
	learnset 50, DRILL_PECK ; Discharge → Drill Peck
	learnset 57, RAIN_DANCE
	learnset 64, LIGHT_SCREEN
	learnset 71, THUNDER ; Drill Peck → Thunder
	learnset 78, BRAVE_BIRD ; Thunder → new move
	learnset 85, ROOST
	learnset 92, HURRICANE ; Zap Cannon → new move
	learnset 99, THUNDERBOLT

	evos_attacks ZapdosGalarian
	learnset 1, PECK
	learnset 1, LOW_KICK ; Rock Smash → TR move
	learnset 1, LEER ; LGPE move
	learnset 8, BULK_UP
	learnset 15, PROTECT ; Detect → similar move
	learnset 22, COUNTER ; Pluck → Counter
	learnset 29, ANCIENTPOWER
	learnset 36, AGILITY ; Charge → Agility
	learnset 43, ROCK_TOMB
	learnset 50, DRILL_PECK ; Discharge → Drill Peck
	learnset 57, BULK_UP
	learnset 64, LIGHT_SCREEN
	learnset 71, CLOSE_COMBAT
	learnset 78, BRAVE_BIRD ; Counter → TR move
	learnset 85, HI_JUMP_KICK ; Quick Guard → new move
	learnset 92, HURRICANE
	learnset 99, REVERSAL

	evos_attacks MoltresPlain
	learnset 1, WING_ATTACK
	learnset 1, EMBER
	learnset 1, LEER ; LGPE move
	learnset 8, FIRE_SPIN
	learnset 15, SAFEGUARD ; Agility → Safeguard
	learnset 22, EXTRASENSORY ; Endure → event move
	learnset 29, ANCIENTPOWER
	learnset 36, AGILITY ; Flamethrower → Agility
	learnset 43, FLAMETHROWER ; Safeguard → Flamethrower
	learnset 50, AIR_SLASH
	learnset 57, SUNNY_DAY
	learnset 64, WILL_O_WISP ; Heat Wave → event move
	learnset 71, FIRE_BLAST ; Solar Beam → TM move
	learnset 78, BRAVE_BIRD ; Sky Attack → new move
	learnset 85, ROOST
	learnset 92, HURRICANE
	learnset 99, SOLAR_BEAM

	evos_attacks MoltresGalarian
	learnset 1, GUST
	learnset 1, PURSUIT ; Payback → new move
	learnset 1, LEER
	learnset 8, FEINT_ATTACK ; new move
	learnset 15, SAFEGUARD
	learnset 22, WING_ATTACK
	learnset 29, ANCIENTPOWER
	learnset 36, AGILITY ; Flamethrower → Agility
	learnset 43, SUCKER_PUNCH
	learnset 50, AIR_SLASH
	learnset 57, NASTY_PLOT ; After You → Nasty Plot
	learnset 64, DARK_PULSE ; Fiery Wrath → similar move
	learnset 71, HEX ; Nasty Plot → TR move
	learnset 78, BRAVE_BIRD ; Sky Attack → new move
	learnset 85, PAIN_SPLIT ; Memento → new move
	learnset 92, HURRICANE
	learnset 99, NIGHT_SLASH ; new move

	evos_attacks Dratini
	evo_data EVOLVE_LEVEL, 30, DRAGONAIR
	learnset 1, LEER
	learnset 1, WRAP
	learnset 10, THUNDER_WAVE
	learnset 20, AGILITY
	learnset 31, AQUA_TAIL
	learnset 40, SAFEGUARD
	learnset 45, RAIN_DANCE
	learnset 50, DRAGON_DANCE
	learnset 55, OUTRAGE
	learnset 60, HYPER_BEAM
	evos_attacks Dragonair
	evo_data EVOLVE_LEVEL, 55, DRAGONITE
	learnset 1, LEER
	learnset 1, THUNDER_WAVE
	learnset 1, WRAP
	learnset 20, AGILITY
	learnset 33, AQUA_TAIL
	learnset 46, SAFEGUARD
	learnset 53, RAIN_DANCE
	learnset 60, DRAGON_DANCE
	learnset 67, OUTRAGE
	learnset 74, HYPER_BEAM
	evos_attacks Dragonite
	learnset 0, HURRICANE
	learnset 1, EXTREMESPEED
	learnset 1, FIRE_PUNCH
	learnset 1, LEER
	learnset 1, ROOST
	learnset 1, THUNDERPUNCH
	learnset 1, THUNDER_WAVE
	learnset 1, WING_ATTACK
	learnset 1, WRAP
	learnset 20, AGILITY
	learnset 33, AQUA_TAIL
	learnset 41, OUTRAGE
	learnset 46, SAFEGUARD
	learnset 53, RAIN_DANCE
	learnset 62, DRAGON_DANCE
	learnset 80, HYPER_BEAM
	evos_attacks Mewtwo
	learnset 1, TELEPORT ; Psywave → RBY TM move
	learnset 1, AGILITY ; Sw/Sh move
	learnset 1, BULK_UP ; Laser Focus → similar move
	learnset 1, CONFUSION
	learnset 1, DISABLE
	learnset 10, SAFEGUARD
	learnset 19, SWIFT
	learnset 28, FUTURE_SIGHT
	learnset 37, BARRIER ; Psych Up → Barrier
	learnset 46, RECOVER
	learnset 55, PSYCHIC_M
	learnset 64, POWER_GEM ; Barrier → SV TM move
	learnset 73, AURA_SPHERE
	learnset 82, AMNESIA
	learnset 91, NASTY_PLOT ; Mist → Mew move
	learnset 100, PSYCHIC_M

	evos_attacks Mew
	learnset 1, SKETCH ; Reflect Type → new move
	learnset 1, TELEPORT ; event move
	learnset 1, TACKLE ; Pound → similar move
	learnset 1, METRONOME
	learnset 1, CONFUSION ; LGPE move
	learnset 10, HEADBUTT ; Mega Punch → TM move
	learnset 20, METRONOME
	learnset 30, PSYCHIC_M
	learnset 40, BARRIER
	learnset 50, ANCIENTPOWER
	learnset 60, BATON_PASS ; Amnesia → Baton Pass
	learnset 70, SAFEGUARD ; Me First → Mewtwo move
	learnset 80, AMNESIA ; Baton Pass → Amnesia
	learnset 90, NASTY_PLOT
	learnset 100, AURA_SPHERE

	evos_attacks Chikorita
	evo_data EVOLVE_LEVEL, 16, BAYLEEF
	learnset 1, TACKLE
	learnset 1, GROWL
	learnset 6, RAZOR_LEAF
	learnset 9, POISONPOWDER
	learnset 12, HEALINGLIGHT ; Synthesis → similar move
	learnset 17, REFLECT
	learnset 17, LIGHT_SCREEN
	learnset 20, DISARM_VOICE ; Magical Leaf → new move
	learnset 23, ENERGY_BALL ; Natural Gift → tutor move
	learnset 28, ANCIENTPOWER ; Sweet Scent → HGSS tutor move
	learnset 31, GROWTH ; Light Screen → new move
	learnset 34, BODY_SLAM
	learnset 39, SAFEGUARD
	learnset 42, PLAY_ROUGH ; Aromatherapy → new move
	learnset 45, SOLAR_BEAM
	learnset 48, HEAL_BELL ; Aromatherapy → similar move
	learnset 51, OUTRAGE ; HGSS tutor move
	learnset 56, MOONBLAST ; new move

	evos_attacks Bayleef
	evo_data EVOLVE_LEVEL, 32, MEGANIUM
	learnset 1, TACKLE
	learnset 1, GROWL
	learnset 6, RAZOR_LEAF
	learnset 9, POISONPOWDER
	learnset 12, HEALINGLIGHT ; Synthesis → similar move
	learnset 18, REFLECT
	learnset 18, LIGHT_SCREEN
	learnset 22, DISARM_VOICE ; Magical Leaf → new move
	learnset 26, ENERGY_BALL ; Natural Gift → tutor move
	learnset 32, ANCIENTPOWER ; Sweet Scent → HGSS tutor move
	learnset 36, GROWTH ; Light Screen → new move
	learnset 40, BODY_SLAM
	learnset 43, SAFEGUARD
	learnset 47, PLAY_ROUGH ; Aromatherapy → new move
	learnset 51, SOLAR_BEAM
	learnset 54, HEAL_BELL ; Aromatherapy → similar move
	learnset 58, OUTRAGE ; HGSS tutor move
	learnset 64, MOONBLAST ; new move

	evos_attacks Meganium
	learnset 1, PETAL_DANCE ; evolution move
	learnset 1, TACKLE
	learnset 1, GROWL
	learnset 6, RAZOR_LEAF
	learnset 9, POISONPOWDER
	learnset 12, HEALINGLIGHT ; Synthesis → similar move
	learnset 18, REFLECT
	learnset 18, LIGHT_SCREEN
	learnset 22, DISARM_VOICE ; Magical Leaf → new move
	learnset 26, ENERGY_BALL ; Natural Gift → tutor move
	learnset 34, ANCIENTPOWER ; Sweet Scent → HGSS tutor move
	learnset 40, GROWTH ; Light Screen → new move
	learnset 46, BODY_SLAM
	learnset 50, SAFEGUARD
	learnset 56, PLAY_ROUGH ; Aromatherapy → new move
	learnset 62, SOLAR_BEAM
	learnset 66, HEAL_BELL ; Aromatherapy → similar move
	learnset 72, OUTRAGE ; HGSS tutor move
	learnset 80, MOONBLAST ; new move

	evos_attacks Cyndaquil
	evo_data EVOLVE_LEVEL, 14, QUILAVA
	learnset 1, TACKLE
	learnset 1, LEER
	learnset 6, SMOKESCREEN
	learnset 10, EMBER
	learnset 13, QUICK_ATTACK
	learnset 19, DEFENSE_CURL ; Flame Wheel → Defense Curl
	learnset 22, FLAME_CHARGE ; Defense Curl → Flame Charge
	learnset 28, DIG ; Flame Charge → TM move
	learnset 31, SWIFT
	learnset 37, REVERSAL ; Lava Plume → egg move
	learnset 40, FLAMETHROWER
	learnset 46, EARTH_POWER ; Inferno → new move
	learnset 49, ROLLOUT
	learnset 55, DOUBLE_EDGE
	learnset 58, EARTHQUAKE ; Burn Up → TM move
	learnset 64, FLARE_BLITZ ; Eruption → egg move

	evos_attacks Quilava
	evo_data EVOLVE_LEVEL, 36, TYPHLOSION
	learnset 1, TACKLE
	learnset 1, LEER
	learnset 6, SMOKESCREEN
	learnset 10, EMBER
	learnset 13, QUICK_ATTACK
	learnset 20, DEFENSE_CURL ; Flame Wheel → Defense Curl
	learnset 24, FLAME_CHARGE ; Defense Curl → Flame Charge
	learnset 31, SWIFT
	learnset 35, DIG ; Flame Charge → TM move
	learnset 42, REVERSAL ; Lava Plume → egg move
	learnset 46, FLAMETHROWER
	learnset 53, EARTH_POWER ; Inferno → new move
	learnset 57, ROLLOUT
	learnset 64, DOUBLE_EDGE
	learnset 68, EARTHQUAKE ; Burn Up → TM move
	learnset 75, FLARE_BLITZ ; Eruption → egg move

	evos_attacks TyphlosionPlain
	learnset 1, FIRE_PUNCH ; evolution move
	learnset 1, TACKLE
	learnset 1, LEER
	learnset 6, SMOKESCREEN
	learnset 10, EMBER
	learnset 13, QUICK_ATTACK
	learnset 20, DEFENSE_CURL ; Flame Wheel → Defense Curl
	learnset 24, FLAME_CHARGE ; Defense Curl → Flame Charge
	learnset 31, SWIFT
	learnset 35, DIG ; Flame Charge → TM move
	learnset 43, REVERSAL ; Lava Plume → egg move
	learnset 48, FLAMETHROWER
	learnset 56, EARTH_POWER ; Inferno → new move
	learnset 61, ROLLOUT
	learnset 69, DOUBLE_EDGE
	learnset 74, EARTHQUAKE ; Burn Up → TM move
	learnset 81, FLARE_BLITZ ; Eruption → egg move

	evos_attacks TyphlosionHisuian
	learnset 1, SHADOW_CLAW ; evolution move
	learnset 1, ASTONISH ; new move
	learnset 1, TACKLE
	learnset 1, LEER
	learnset 6, SMOKESCREEN
	learnset 10, EMBER
	learnset 13, QUICK_ATTACK
	learnset 20, DEFENSE_CURL ; Flame Wheel → Defense Curl
	learnset 24, FLAME_CHARGE ; Defense Curl → Flame Charge
	learnset 31, SWIFT
	learnset 35, HEX
	learnset 43, WILL_O_WISP ; Lava Plume → TM move
	learnset 48, FLAMETHROWER
	learnset 56, SHADOW_BALL
	learnset 61, ROLLOUT
	learnset 69, DOUBLE_EDGE
	learnset 74, DARK_PULSE ; Infernal Parade → new move
	learnset 81, FLARE_BLITZ ; Eruption → egg move

	evos_attacks Totodile
	evo_data EVOLVE_LEVEL, 18, CROCONAW
	learnset 1, SCRATCH
	learnset 1, LEER
	learnset 6, WATER_GUN
	learnset 8, RAGE
	learnset 13, BITE
	learnset 15, SCARY_FACE
	learnset 20, METAL_CLAW ; Ice Fang → egg move
	learnset 22, REVERSAL ; Flail → similar move
	learnset 27, AGILITY ; Feraligatr move
	learnset 29, CRUNCH
	learnset 34, ANCIENTPOWER ; Chip Away → HGSS tutor move
	learnset 36, SLASH
	learnset 41, SCREECH
	learnset 43, THRASH
	learnset 48, AQUA_TAIL
	learnset 50, CLOSE_COMBAT ; Superpower → similar move
	learnset 56, HYDRO_PUMP

	evos_attacks Croconaw
	evo_data EVOLVE_LEVEL, 30, FERALIGATR
	learnset 1, SCRATCH
	learnset 1, LEER
	learnset 6, WATER_GUN
	learnset 8, RAGE
	learnset 13, BITE
	learnset 15, SCARY_FACE
	learnset 21, METAL_CLAW ; Ice Fang → egg move
	learnset 24, REVERSAL ; Flail → similar move
	learnset 30, AGILITY ; Feraligatr move
	learnset 33, CRUNCH
	learnset 39, ANCIENTPOWER ; Chip Away → HGSS tutor move
	learnset 42, SLASH
	learnset 48, SCREECH
	learnset 51, THRASH
	learnset 57, AQUA_TAIL
	learnset 60, CLOSE_COMBAT ; Superpower → similar move
	learnset 66, HYDRO_PUMP

	evos_attacks Feraligatr
	learnset 1, NIGHT_SLASH ; evolution move
	learnset 1, SCRATCH
	learnset 1, LEER
	learnset 6, WATER_GUN
	learnset 8, RAGE
	learnset 13, BITE
	learnset 15, SCARY_FACE
	learnset 21, METAL_CLAW ; Ice Fang → egg move
	learnset 24, REVERSAL ; Flail → similar move
	learnset 32, AGILITY
	learnset 37, CRUNCH
	learnset 45, ANCIENTPOWER ; Chip Away → HGSS tutor move
	learnset 50, SLASH
	learnset 56, SCREECH
	learnset 62, THRASH
	learnset 68, OUTRAGE ; HGSS tutor move
	learnset 73, AQUA_TAIL
	learnset 78, CLOSE_COMBAT ; Superpower → similar move
	learnset 84, HYDRO_PUMP

	evos_attacks Sentret
	evo_data EVOLVE_LEVEL, 15, FURRET
	learnset 1, SCRATCH
	learnset 4, DEFENSE_CURL
	learnset 7, QUICK_ATTACK
	learnset 13, FURY_STRIKES
	learnset 28, REST
	learnset 31, SUCKER_PUNCH
	learnset 36, AMNESIA
	learnset 39, BATON_PASS
	learnset 42, DOUBLE_EDGE
	learnset 47, HYPER_VOICE
	evos_attacks Furret
	learnset 0, AGILITY
	learnset 1, DEFENSE_CURL
	learnset 1, QUICK_ATTACK
	learnset 1, SCRATCH
	learnset 13, FURY_STRIKES
	learnset 32, REST
	learnset 36, SUCKER_PUNCH
	learnset 42, AMNESIA
	learnset 46, BATON_PASS
	learnset 50, DOUBLE_EDGE
	learnset 56, HYPER_VOICE
	evos_attacks Hoothoot
	evo_data EVOLVE_LEVEL, 20, NOCTOWL
	learnset 1, GROWL
	learnset 1, PECK
	learnset 3, TACKLE
	learnset 9, CONFUSION
	learnset 12, REFLECT
	learnset 15, DEFOG
	learnset 18, AIR_SLASH
	learnset 21, EXTRASENSORY
	learnset 24, TAKE_DOWN
	learnset 30, ROOST
	learnset 33, MOONBLAST
	learnset 36, HYPNOSIS
	learnset 39, DREAM_EATER
	evos_attacks Noctowl
	learnset 1, GROWL
	learnset 1, PECK
	learnset 1, TACKLE
	learnset 9, CONFUSION
	learnset 12, REFLECT
	learnset 18, AIR_SLASH
	learnset 23, EXTRASENSORY
	learnset 28, TAKE_DOWN
	learnset 38, ROOST
	learnset 43, MOONBLAST
	learnset 48, HYPNOSIS
	learnset 53, DREAM_EATER
	evos_attacks Ledyba
	evo_data EVOLVE_LEVEL, 18, LEDIAN
	learnset 1, TACKLE
	learnset 5, SUPERSONIC
	learnset 8, SWIFT
	learnset 12, LIGHT_SCREEN
	learnset 12, REFLECT
	learnset 12, SAFEGUARD
	learnset 15, MACH_PUNCH
	learnset 26, BATON_PASS
	learnset 29, AGILITY
	learnset 33, BUG_BUZZ
	learnset 36, AIR_SLASH
	learnset 40, DOUBLE_EDGE
	evos_attacks Ledian
	learnset 1, SUPERSONIC
	learnset 1, SWIFT
	learnset 1, TACKLE
	learnset 12, LIGHT_SCREEN
	learnset 12, REFLECT
	learnset 12, SAFEGUARD
	learnset 15, MACH_PUNCH
	learnset 29, BATON_PASS
	learnset 33, AGILITY
	learnset 38, BUG_BUZZ
	learnset 42, AIR_SLASH
	learnset 47, DOUBLE_EDGE
	evos_attacks Spinarak
	evo_data EVOLVE_LEVEL, 22, ARIADOS
	learnset 1, POISON_STING
	learnset 1, STRING_SHOT
	learnset 5, ABSORB
	learnset 12, SCARY_FACE
	learnset 15, NIGHT_SHADE
	learnset 22, FURY_STRIKES
	learnset 26, SUCKER_PUNCH
	learnset 29, AGILITY
	learnset 33, PIN_MISSILE
	learnset 36, PSYCHIC_M
	learnset 40, POISON_JAB
	evos_attacks Ariados
	learnset 0, SWORDS_DANCE
	learnset 1, ABSORB
	learnset 1, BUG_BITE
	learnset 1, POISON_STING
	learnset 1, STRING_SHOT
	learnset 12, SCARY_FACE
	learnset 15, NIGHT_SHADE
	learnset 23, FURY_STRIKES
	learnset 28, SUCKER_PUNCH
	learnset 31, AGILITY
	learnset 35, PIN_MISSILE
	learnset 41, PSYCHIC_M
	learnset 46, POISON_JAB
	evos_attacks Crobat
	learnset 1, ABSORB
	learnset 1, ASTONISH
	learnset 1, MEAN_LOOK
	learnset 1, SCREECH
	learnset 1, SUPERSONIC
	learnset 1, TAILWIND
	learnset 1, TOXIC
	learnset 34, BITE
	learnset 41, HAZE
	learnset 48, VENOSHOCK
	learnset 55, CONFUSE_RAY
	learnset 62, AIR_SLASH
	learnset 69, LEECH_LIFE
	evos_attacks Chinchou
	evo_data EVOLVE_LEVEL, 27, LANTURN
	learnset 1, SUPERSONIC
	learnset 1, WATER_GUN
	learnset 8, THUNDER_WAVE
	learnset 12, BUBBLE_BEAM
	learnset 16, CONFUSE_RAY
	learnset 20, SPARK
	learnset 40, TAKE_DOWN
	learnset 44, HYDRO_PUMP
	evos_attacks Lanturn
	learnset 1, SUPERSONIC
	learnset 1, THUNDER_WAVE
	learnset 1, WATER_GUN
	learnset 12, BUBBLE_BEAM
	learnset 16, CONFUSE_RAY
	learnset 20, SPARK
	learnset 48, TAKE_DOWN
	learnset 54, HYDRO_PUMP
	evos_attacks Pichu
	evo_data EVOLVE_HAPPINESS, TR_ANYTIME, PIKACHU
	learnset 1, THUNDERSHOCK
	learnset 8, SWEET_KISS
	learnset 16, NASTY_PLOT
	learnset 20, CHARM
	evos_attacks Cleffa
	evo_data EVOLVE_HAPPINESS, TR_ANYTIME, CLEFAIRY
	learnset 1, SPLASH
	learnset 4, SING
	learnset 8, SWEET_KISS
	learnset 12, DISARM_VOICE
	learnset 16, ENCORE
	learnset 20, CHARM
	evos_attacks Igglybuff
	evo_data EVOLVE_HAPPINESS, TR_ANYTIME, JIGGLYPUFF
	learnset 1, SING
	learnset 1, TACKLE ; Pound → similar move
	learnset 1, DEFENSE_CURL ; Copycat → Defense Curl
	learnset 4, ROLLOUT ; Defense Curl → tutor move
	learnset 8, SWEET_KISS
	learnset 12, DISARM_VOICE
	learnset 16, DISABLE
	learnset 20, CHARM

	evos_attacks Togepi
	evo_data EVOLVE_HAPPINESS, TR_ANYTIME, TOGETIC
	learnset 1, GROWL
	learnset 4, SWEET_KISS
	learnset 12, CHARM
	learnset 16, ANCIENTPOWER
	learnset 20, YAWN
	learnset 24, METRONOME
	learnset 32, DOUBLE_EDGE
	learnset 36, SAFEGUARD
	learnset 44, BATON_PASS
	evos_attacks Togetic
	evo_data EVOLVE_ITEM, SHINY_STONE, TOGEKISS
	learnset 1, GROWL
	learnset 1, SWEET_KISS
	learnset 12, CHARM
	learnset 16, ANCIENTPOWER
	learnset 20, YAWN
	learnset 24, METRONOME
	learnset 32, DOUBLE_EDGE
	learnset 36, SAFEGUARD
	learnset 44, BATON_PASS
	evos_attacks Natu
	evo_data EVOLVE_LEVEL, 25, XATU
	learnset 1, LEER
	learnset 1, PECK
	learnset 10, TELEPORT
	learnset 15, CONFUSE_RAY
	learnset 20, NIGHT_SHADE
	learnset 35, PSYCHIC_M
	learnset 45, FUTURE_SIGHT
	evos_attacks Xatu
	learnset 0, AIR_SLASH
	learnset 1, LEER
	learnset 1, PECK
	learnset 1, TAILWIND
	learnset 1, TELEPORT
	learnset 15, CONFUSE_RAY
	learnset 20, NIGHT_SHADE
	learnset 41, PSYCHIC_M
	learnset 55, FUTURE_SIGHT
	evos_attacks Mareep
	evo_data EVOLVE_LEVEL, 15, FLAAFFY
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 4, THUNDER_WAVE
	learnset 8, THUNDERSHOCK
	learnset 18, TAKE_DOWN
	learnset 25, CONFUSE_RAY
	learnset 29, POWER_GEM
	learnset 43, LIGHT_SCREEN
	learnset 46, THUNDER
	evos_attacks Flaaffy
	evo_data EVOLVE_LEVEL, 30, AMPHAROS
	evo_data EVOLVE_LEVEL, 36, AMPHAROS
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 6, THUNDERSHOCK
	learnset 9, THUNDER_WAVE
	learnset 20, TAKE_DOWN
	learnset 29, CONFUSE_RAY
	learnset 34, POWER_GEM
	learnset 52, LIGHT_SCREEN
	learnset 56, THUNDER
	evos_attacks Ampharos
	learnset 0, THUNDERPUNCH
	learnset 1, DRAGON_PULSE
	learnset 1, FIRE_PUNCH
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 1, THUNDERSHOCK
	learnset 1, THUNDER_WAVE
	learnset 20, TAKE_DOWN
	learnset 29, CONFUSE_RAY
	learnset 35, POWER_GEM
	learnset 57, LIGHT_SCREEN
	learnset 62, THUNDER
	evos_attacks Bellossom
	learnset 1, ABSORB
	learnset 1, ACID
	learnset 1, GIGA_DRAIN
	learnset 1, GROWTH
	learnset 1, MEGA_DRAIN
	learnset 1, MOONBLAST
	learnset 1, PETAL_DANCE
	learnset 1, POISONPOWDER
	learnset 1, SLEEP_POWDER
	learnset 1, STUN_SPORE
	learnset 1, TOXIC
	evos_attacks Marill
	evo_data EVOLVE_LEVEL, 18, AZUMARILL
	learnset 1, DEFENSE_CURL
	learnset 1, ROLLOUT
	learnset 1, TACKLE
	learnset 1, WATER_GUN
	learnset 6, BUBBLE_BEAM
	learnset 9, CHARM
	learnset 19, AQUA_TAIL
	learnset 21, PLAY_ROUGH
	learnset 27, RAIN_DANCE
	learnset 30, HYDRO_PUMP
	learnset 33, DOUBLE_EDGE
	evos_attacks Azumarill
	learnset 1, DEFENSE_CURL
	learnset 1, ROLLOUT
	learnset 1, TACKLE
	learnset 1, WATER_GUN
	learnset 6, BUBBLE_BEAM
	learnset 9, CHARM
	learnset 21, AQUA_TAIL
	learnset 25, PLAY_ROUGH
	learnset 35, RAIN_DANCE
	learnset 40, HYDRO_PUMP
	learnset 45, DOUBLE_EDGE
	evos_attacks Sudowoodo
	learnset 1, SUBSTITUTE ; Copycat → event move
	learnset 5, REVERSAL ; Flail → similar move
	learnset 8, LOW_KICK
	learnset 12, LEER ; Rock Throw → new move
	learnset 15, ROCK_THROW ; Mimic → Rock Throw
	learnset 19, FEINT_ATTACK
	learnset 22, ANCIENTPOWER ; Rock Tomb → new move
	learnset 26, SPIKES ; Block → SV TM move
	learnset 29, ROCK_SLIDE
	learnset 33, COUNTER
	learnset 36, SUCKER_PUNCH
	learnset 40, DOUBLE_EDGE
	learnset 43, STONE_EDGE ; evolution move
	learnset 47, CLOSE_COMBAT ; Hammer Arm → similar move
	learnset 50, IRON_HEAD ; Head Smash → tutor move

	evos_attacks Politoed
	learnset 1, GIGA_DRAIN ; Bounce → TM move ; evolution move
	learnset 1, BUBBLE_BEAM
	learnset 1, HYPNOSIS
	learnset 1, DOUBLE_SLAP
	learnset 1, PERISH_SONG
	learnset 27, SWAGGER
	learnset 48, HYPER_VOICE

	evos_attacks Hoppip
	evo_data EVOLVE_LEVEL, 18, SKIPLOOM
	learnset 1, SPLASH
	learnset 1, TACKLE
	learnset 6, ABSORB
	learnset 10, POISONPOWDER
	learnset 10, SLEEP_POWDER
	learnset 10, STUN_SPORE
	learnset 19, LEECH_SEED
	learnset 22, MEGA_DRAIN
	learnset 24, ACROBATICS
	learnset 29, U_TURN
	learnset 32, GIGA_DRAIN
	evos_attacks Skiploom
	evo_data EVOLVE_LEVEL, 27, JUMPLUFF
	learnset 1, ABSORB
	learnset 1, SPLASH
	learnset 8, TACKLE
	learnset 12, POISONPOWDER
	learnset 12, SLEEP_POWDER
	learnset 12, STUN_SPORE
	learnset 20, LEECH_SEED
	learnset 24, MEGA_DRAIN
	learnset 28, ACROBATICS
	learnset 34, U_TURN
	learnset 37, GIGA_DRAIN
	evos_attacks Jumpluff
	learnset 1, ABSORB
	learnset 1, SPLASH
	learnset 8, TACKLE
	learnset 12, POISONPOWDER
	learnset 12, SLEEP_POWDER
	learnset 12, STUN_SPORE
	learnset 20, LEECH_SEED
	learnset 24, MEGA_DRAIN
	learnset 30, ACROBATICS
	learnset 39, U_TURN
	learnset 43, GIGA_DRAIN
	evos_attacks Aipom
	evo_data EVOLVE_MOVE, DOUBLE_SLAP, AMBIPOM
	learnset 1, SCRATCH
	learnset 8, ASTONISH
	learnset 11, BATON_PASS
	learnset 18, FURY_STRIKES
	learnset 22, SWIFT
	learnset 25, SCREECH
	learnset 29, AGILITY
	learnset 39, NASTY_PLOT
	evos_attacks Sunkern
	evo_data EVOLVE_ITEM, SUN_STONE, SUNFLORA
	learnset 1, GROWTH
	learnset 1, TACKLE
	learnset 7, ABSORB
	learnset 10, MEGA_DRAIN
	learnset 16, RAZOR_LEAF
	learnset 22, GIGA_DRAIN
	learnset 31, SOLAR_BEAM
	learnset 34, DOUBLE_EDGE
	learnset 36, SUNNY_DAY
	learnset 39, SEED_BOMB
	evos_attacks Sunflora
	learnset 1, GROWTH
	learnset 1, TACKLE
	learnset 7, ABSORB
	learnset 10, MEGA_DRAIN
	learnset 13, LEECH_SEED
	learnset 16, RAZOR_LEAF
	learnset 22, GIGA_DRAIN
	learnset 28, PETAL_DANCE
	learnset 31, SOLAR_BEAM
	learnset 34, DOUBLE_EDGE
	learnset 39, SUNNY_DAY

	evos_attacks Yanma
	evo_data EVOLVE_MOVE, ANCIENTPOWER, YANMEGA
	learnset 1, TACKLE
	learnset 1, FORESIGHT
	learnset 1, BUG_BITE
	learnset 6, QUICK_ATTACK
	learnset 11, DOUBLE_TEAM
	learnset 14, SONIC_BOOM
	learnset 17, PROTECT ; Detect → similar move
	learnset 22, DRAGON_RAGE ; Supersonic → new move
	learnset 27, SUPERSONIC ; Uproar → Supersonic
	learnset 30, PURSUIT
if DEF(FAITHFUL)
	learnset 33, ANCIENTPOWER
else
	learnset 35, ANCIENTPOWER
endc
	learnset 38, HYPNOSIS
	learnset 43, WING_ATTACK
	learnset 46, SCREECH
	learnset 49, U_TURN
	learnset 54, AIR_SLASH
	learnset 57, BUG_BUZZ
	learnset 62, DREAM_EATER ; event move

	evos_attacks WooperPlain
	evo_data EVOLVE_LEVEL, 20, QUAGSIRE
	learnset 1, WATER_GUN
	learnset 4, RAIN_DANCE
	learnset 12, HAZE
	learnset 21, YAWN
	learnset 24, AQUA_TAIL
	learnset 32, AMNESIA
	learnset 36, TOXIC
	learnset 40, EARTHQUAKE
	evos_attacks WooperPaldean
	evo_data EVOLVE_LEVEL, 20, CLODSIRE
	learnset 1, MUD_SLAP ; Mud Shot → similar move
	learnset 1, LEER ; Tail Whip → similar move
	learnset 5, TACKLE
	learnset 9, POISON_STING ; Poison Tail → similar move
	learnset 15, HEADBUTT ; Slam → tutor move
	learnset 19, RECOVER ; Mud Bomb → egg move
	learnset 23, AMNESIA
	learnset 29, YAWN ; Yawn
	learnset 33, EARTHQUAKE
	learnset 37, POISON_JAB
	learnset 43, TOXIC_SPIKES
	learnset 47, GUNK_SHOT ; Sludge Wave → similar move

	evos_attacks Quagsire
	learnset 1, RAIN_DANCE
	learnset 1, WATER_GUN
	learnset 12, HAZE
	learnset 23, YAWN
	learnset 28, AQUA_TAIL
	learnset 40, AMNESIA
	learnset 46, TOXIC
	learnset 52, EARTHQUAKE
	evos_attacks Espeon
	learnset 0, CONFUSION
	learnset 1, BATON_PASS
	learnset 1, BITE
	learnset 1, CHARM
	learnset 1, DOUBLE_EDGE
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 1, TAKE_DOWN
	learnset 10, QUICK_ATTACK
	learnset 20, SWIFT
	learnset 25, PSYBEAM
	learnset 40, PSYCHIC_M
	learnset 50, FUTURE_SIGHT
	evos_attacks Umbreon
	learnset 1, BATON_PASS
	learnset 1, BITE
	learnset 1, CHARM
	learnset 1, DOUBLE_EDGE
	learnset 1, GROWL
	learnset 1, SWIFT
	learnset 1, TACKLE
	learnset 1, TAKE_DOWN
	learnset 10, QUICK_ATTACK
	learnset 20, CONFUSE_RAY
	learnset 40, DARK_PULSE
	learnset 45, SCREECH
	learnset 50, MEAN_LOOK
	evos_attacks Murkrow
	evo_data EVOLVE_ITEM, DUSK_STONE, HONCHKROW
	learnset 1, ASTONISH
	learnset 1, PECK
	learnset 5, GUST
	learnset 11, HAZE
	learnset 15, WING_ATTACK
	learnset 21, NIGHT_SHADE
	learnset 31, TAUNT
	learnset 35, MEAN_LOOK
	learnset 50, SUCKER_PUNCH
	learnset 55, TORMENT
	evos_attacks SlowkingPlain
	learnset 1, CURSE
	learnset 1, GROWL
	learnset 1, NASTY_PLOT
	learnset 1, POWER_GEM
	learnset 1, SWAGGER
	learnset 1, TACKLE
	learnset 1, WATER_GUN
	learnset 9, YAWN
	learnset 12, CONFUSION
	learnset 15, DISABLE
	learnset 18, WATER_PULSE
	learnset 21, HEADBUTT
	learnset 27, AMNESIA
	learnset 36, PSYCHIC_M
	learnset 42, RAIN_DANCE
	evos_attacks SlowkingGalarian
	learnset 1, HEX ; Eerie Spell → Sw/Sh TR move ; evolution move
	learnset 1, POWER_GEM
	learnset 1, HIDDEN_POWER
	learnset 1, CURSE
	learnset 1, TACKLE
	learnset 5, GROWL
	learnset 9, ACID
	learnset 14, CONFUSION
	learnset 19, DISABLE
	learnset 23, HEADBUTT
	learnset 28, WATER_PULSE
	learnset 32, ZEN_HEADBUTT
	learnset 36, NASTY_PLOT
	learnset 41, SWAGGER
	learnset 45, PSYCHIC_M
	learnset 49, RAIN_DANCE ; Trump Card → TM move
	learnset 54, BELLY_DRUM ; Psych Up → egg move
	learnset 58, RECOVER ; Heal Pulse → similar move

	evos_attacks Misdreavus
	evo_data EVOLVE_ITEM, DUSK_STONE, MISMAGIUS
	learnset 1, CONFUSION
	learnset 1, GROWL
	learnset 10, ASTONISH
	learnset 14, CONFUSE_RAY
	learnset 19, MEAN_LOOK
	learnset 23, HEX
	learnset 28, PSYBEAM
	learnset 32, PAIN_SPLIT
	learnset 41, SHADOW_BALL
	learnset 46, PERISH_SONG
	learnset 50, POWER_GEM
	evos_attacks Unown
	learnset 1, HIDDEN_POWER

	evos_attacks Wobbuffet
	learnset 1, SPLASH
	learnset 1, CHARM
	learnset 1, ENCORE
	learnset 1, AMNESIA
	learnset 1, RECOVER ; evolve move
	learnset 1, COUNTER
	learnset 1, MIRROR_COAT
	learnset 1, SAFEGUARD
	learnset 1, DESTINY_BOND

	evos_attacks Girafarig
	evo_data EVOLVE_MOVE, ZEN_HEADBUTT, FARIGIRAF
	learnset 1, ASTONISH
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 5, CONFUSION
	learnset 14, STOMP
	learnset 19, PSYBEAM
	learnset 23, AGILITY
	learnset 37, CRUNCH
	learnset 41, BATON_PASS
	learnset 46, NASTY_PLOT
	learnset 50, PSYCHIC_M
if !DEF(FAITHFUL)
	learnset 55, DARK_PULSE ; new move
endc
	evos_attacks Farigiraf
	learnset 1, ASTONISH
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 5, CONFUSION
	learnset 14, STOMP
	learnset 19, PSYBEAM
	learnset 23, AGILITY
	learnset 37, CRUNCH
	learnset 41, BATON_PASS
	learnset 46, NASTY_PLOT
	learnset 50, PSYCHIC_M
if !DEF(FAITHFUL)
	learnset 55, DARK_PULSE ; new move
endc
	evos_attacks Pineco
	evo_data EVOLVE_LEVEL, 31, FORRETRESS
	learnset 1, TACKLE
	learnset 1, PROTECT
	learnset 6, BULK_UP ; Self-Destruct → TCG move
	learnset 9, BUG_BITE
	learnset 12, SUBSTITUTE ; Take Down → event move
	learnset 17, RAPID_SPIN
	learnset 20, DEFENSE_CURL ; Bide → TM move
	learnset 23, TAKE_DOWN ; Natural Gift → Take Down
	learnset 28, SPIKES
	learnset 31, REVERSAL ; Payback → new move
	learnset 34, EXPLOSION
	learnset 39, REFLECT ; Iron Defense → egg move
	learnset 42, GYRO_BALL
	learnset 45, DOUBLE_EDGE

	evos_attacks Forretress
	learnset 1, FLASH_CANNON ; Mirror Shot → TM move ; evolution move
	learnset 1, AGILITY ; Autotomize → similar move
	learnset 1, TOXIC_SPIKES
	learnset 1, TACKLE
	learnset 1, PROTECT
	learnset 6, BULK_UP ; Self-Destruct → TCG move
	learnset 9, BUG_BITE
	learnset 12, SUBSTITUTE ; Take Down → event move
	learnset 17, RAPID_SPIN
	learnset 20, DEFENSE_CURL ; Bide → TM move
	learnset 23, TAKE_DOWN ; Natural Gift → Take Down
	learnset 28, SPIKES
	learnset 32, REVERSAL ; Payback → new move
	learnset 36, EXPLOSION
	learnset 42, REFLECT ; Iron Defense → egg move
	learnset 46, GYRO_BALL
	learnset 50, DOUBLE_EDGE
	learnset 56, THUNDERBOLT
	learnset 60, IRON_HEAD ; Heavy Slam → new move

	evos_attacks Dunsparce
	evo_data EVOLVE_LEVEL, 32, DUDUNSPARCE, NO_FORM ; preserve pre-evo form
	learnset 1, DEFENSE_CURL
	learnset 4, MUD_SLAP
	learnset 8, ROLLOUT
	learnset 12, GLARE
	learnset 16, SCREECH
	learnset 20, ANCIENTPOWER
	learnset 28, YAWN
	learnset 36, ROOST
	learnset 48, DOUBLE_EDGE
	evos_attacks Gligar
	evo_data EVOLVE_HOLDING, RAZOR_FANG, TR_EVENITE, GLISCOR
	learnset 1, POISON_STING
	learnset 10, KNOCK_OFF
	learnset 13, QUICK_ATTACK
	learnset 22, ACROBATICS
	learnset 27, SLASH
	learnset 30, U_TURN
	learnset 35, SCREECH
	learnset 40, X_SCISSOR
	learnset 50, SWORDS_DANCE
	evos_attacks Gliscor
	learnset 1, POISON_JAB
	learnset 13, QUICK_ATTACK
	learnset 19, KNOCK_OFF
	learnset 22, ACROBATICS
	learnset 27, NIGHT_SLASH
	learnset 30, U_TURN
	learnset 35, SCREECH
	learnset 40, X_SCISSOR
	learnset 50, SWORDS_DANCE
	evos_attacks Steelix
	learnset 1, CRUNCH
	learnset 1, ROCK_THROW
	learnset 1, TACKLE
	learnset 12, DRAGONBREATH
	learnset 16, CURSE
	learnset 20, ROCK_SLIDE
	learnset 24, SCREECH
	learnset 32, STEALTH_ROCK
	learnset 40, SANDSTORM
	learnset 44, DIG
	learnset 48, IRON_TAIL
	learnset 52, STONE_EDGE
	learnset 56, DOUBLE_EDGE
	evos_attacks Snubbull
	evo_data EVOLVE_LEVEL, 23, GRANBULL
	learnset 1, CHARM
	learnset 1, GROWL
	learnset 1, SCARY_FACE
	learnset 1, TACKLE
	learnset 7, BITE
	learnset 13, LICK
	learnset 19, HEADBUTT
	learnset 25, ROAR
	learnset 37, PLAY_ROUGH
	learnset 49, CRUNCH
	evos_attacks Granbull
	learnset 1, CHARM
	learnset 1, GROWL
	learnset 1, OUTRAGE
	learnset 1, SCARY_FACE
	learnset 1, TACKLE
	learnset 7, BITE
	learnset 13, LICK
	learnset 19, HEADBUTT
	learnset 27, ROAR
	learnset 43, PLAY_ROUGH
	learnset 59, CRUNCH
	evos_attacks QwilfishPlain
	learnset 1, WATER_GUN
	learnset 1, SPIKES
	learnset 1, TACKLE
	learnset 1, POISON_STING
	learnset 5, DEFENSE_CURL ; Harden → TM move
	learnset 9, MINIMIZE
	learnset 13, BUBBLE_BEAM ; Bubble → similar move
	learnset 17, ROLLOUT
	learnset 21, TOXIC_SPIKES
	learnset 25, PAIN_SPLIT ; Stockpile + Spit Up → HGSS move tutor
	learnset 29, REVERSAL ; Revenge → Sw/Sh move
	learnset 33, WATER_PULSE ; Brine → TM move
	learnset 37, PIN_MISSILE
	learnset 41, TAKE_DOWN
	learnset 45, AQUA_TAIL
	learnset 49, POISON_JAB
	learnset 53, DESTINY_BOND
	learnset 57, HYDRO_PUMP
	learnset 60, DOUBLE_EDGE ; Fell Stinger → event move

	evos_attacks QwilfishHisuian
	evo_data EVOLVE_LEVEL, 33, OVERQWIL
	learnset 1, AQUA_JET ; Water Gun → SV TM move
	learnset 1, SPIKES
	learnset 1, TACKLE
	learnset 1, POISON_STING
	learnset 5, DEFENSE_CURL ; Harden → TM move
	learnset 9, MINIMIZE
	learnset 13, PIN_MISSILE
	learnset 17, ROLLOUT
	learnset 21, TOXIC_SPIKES
	learnset 25, PAIN_SPLIT ; Stockpile + Spit Up → HGSS move tutor
	learnset 29, REVERSAL ; Revenge → Sw/Sh move
	learnset 33, WATER_PULSE ; Brine → TM move
	learnset 37, CRUNCH ; Dark Pulse → SV TM move
	learnset 41, TAKE_DOWN
	learnset 45, AQUA_TAIL
	learnset 49, POISON_JAB
	learnset 53, DESTINY_BOND
	learnset 57, EXPLOSION ; Self-Destruct → similar move
	learnset 60, DOUBLE_EDGE ; Fell Stinger → event move

	evos_attacks Scizor
	learnset 1, METAL_CLAW ; evolution move
	learnset 1, BULLET_PUNCH
	learnset 1, QUICK_ATTACK
	learnset 1, LEER
	learnset 5, BULK_UP
	learnset 9, PURSUIT
	learnset 13, FALSE_SWIPE
	learnset 17, AGILITY
	learnset 21, WING_ATTACK
	learnset 25, BUG_BITE ; Fury Cutter → similar move
	learnset 29, SLASH
	learnset 33, BUG_BUZZ ; Razor Wind → egg move
	learnset 37, DEFENSE_CURL ; Iron Defense → similar move
	learnset 41, X_SCISSOR
	learnset 45, CRUNCH ; Night Slash → Prism tutor move
	learnset 49, CLOSE_COMBAT ; Double Hit → SV TM move
	learnset 50, IRON_HEAD
	learnset 57, SWORDS_DANCE

	evos_attacks Shuckle
	learnset 1, MUD_SLAP ; Constrict → GSC TM move
	learnset 1, DEFENSE_CURL ; Withdraw → similar move
	learnset 1, ROLLOUT
	learnset 5, ENCORE
	learnset 9, WRAP
	learnset 12, STRING_SHOT ; Struggle Bug → HGSS tutor move
	learnset 16, SAFEGUARD
	learnset 20, REST
	learnset 23, ROCK_THROW
	learnset 27, ACID ; Gastro Acid → egg move
	learnset 31, DISABLE ; Power Trick → new move
	learnset 34, SHELL_SMASH
	learnset 38, ROCK_BLAST ; Rock Slide → Sw/Sh move
	learnset 42, BUG_BITE
	learnset 45, ROCK_SLIDE ; Power Split + Guard Split → Rock Slide
	learnset 49, REVERSAL ; Stone Edge → Sw/Sh move
	learnset 53, STONE_EDGE ; Sticky Web → Stone Edge

	evos_attacks Heracross
	learnset 1, LEER
	learnset 1, TACKLE
	learnset 10, ENDURE
	learnset 15, AERIAL_ACE
	learnset 20, HORN_ATTACK
	learnset 24, BRICK_BREAK
	learnset 25, COUNTER
	learnset 35, PIN_MISSILE
	learnset 45, THRASH
	learnset 50, SWORDS_DANCE
	learnset 55, MEGAHORN
	learnset 60, CLOSE_COMBAT
	evos_attacks SneaselPlain
	evo_data EVOLVE_HOLDING, RAZOR_CLAW, TR_EVENITE, WEAVILE
	learnset 1, LEER
	learnset 1, SCRATCH
	learnset 6, TAUNT
	learnset 12, QUICK_ATTACK
	learnset 18, METAL_CLAW
	learnset 24, ICY_WIND
	learnset 30, FURY_STRIKES
	learnset 36, HONE_CLAWS
	learnset 48, AGILITY
	learnset 54, SCREECH
	learnset 60, SLASH
	evos_attacks SneaselHisuian
	evo_data EVOLVE_HOLDING, RAZOR_CLAW, TR_MORNDAY, SNEASLER
	learnset 1, LEER
	learnset 1, BRICK_BREAK
	learnset 1, SCRATCH
	learnset 6, TAUNT
	learnset 12, QUICK_ATTACK
	learnset 18, METAL_CLAW
	learnset 24, POISON_JAB
	learnset 36, HONE_CLAWS
	learnset 42, SLASH
	learnset 48, AGILITY
	learnset 54, SCREECH
	learnset 60, CLOSE_COMBAT
	evos_attacks Teddiursa
	evo_data EVOLVE_LEVEL, 30, URSARING
	learnset 1, THIEF ; Covet → TM move
	learnset 1, SCRATCH
	learnset 1, GROWL ; Baby-Doll Eyes → similar move
	learnset 1, LICK
	learnset 1, BULK_UP ; Fake Tears → egg move
	learnset 8, FURY_STRIKES ; Fury Swipes → similar move
	learnset 15, FEINT_ATTACK
	learnset 22, BELLY_DRUM ; Sweet Scent → egg move
	learnset 25, PLAY_ROUGH ; Play Nice → egg move
	learnset 29, SLASH
	learnset 36, CHARM
	learnset 43, REST
	learnset 43, CRUNCH ; Snore → egg move
	learnset 50, THRASH
	learnset 57, CLOSE_COMBAT ; Fling → new move
	learnset 64, DOUBLE_EDGE ; new move

	evos_attacks Ursaring
	evo_data EVOLVE_ITEM, MOON_STONE, URSALUNA
	evo_data EVOLVE_LOCATION, SINJOH_RUINS, URSALUNA
	evo_data EVOLVE_LOCATION, MYSTRI_STAGE, URSALUNA
	learnset 1, GUNK_SHOT ; HGSS tutor move
	learnset 1, THIEF ; Covet → TM move
	learnset 1, SCRATCH
	learnset 1, LEER
	learnset 1, LICK
	learnset 1, BULK_UP ; Fake Tears → egg move
	learnset 8, FURY_STRIKES ; Fury Swipes → similar move
	learnset 15, FEINT_ATTACK
	learnset 22, BELLY_DRUM ; Sweet Scent → egg move
	learnset 25, PLAY_ROUGH ; Play Nice → egg move
	learnset 29, SLASH
	learnset 38, SCARY_FACE
	learnset 47, REST
	learnset 49, CRUNCH ; Snore → egg move
	learnset 58, THRASH
	learnset 67, CLOSE_COMBAT ; Hammer Arm → new move
	learnset 76, DOUBLE_EDGE ; new move

	evos_attacks Slugma
	evo_data EVOLVE_LEVEL, 38, MAGCARGO
	learnset 1, YAWN
	learnset 6, EMBER
	learnset 8, ROCK_THROW
	learnset 22, ANCIENTPOWER
	learnset 29, ROCK_SLIDE
	learnset 36, AMNESIA
	learnset 41, BODY_SLAM
	learnset 43, RECOVER
	learnset 48, FLAMETHROWER
	learnset 50, EARTH_POWER
	evos_attacks Magcargo
	learnset 0, SHELL_SMASH
	learnset 1, EARTH_POWER
	learnset 1, EMBER
	learnset 1, ROCK_THROW
	learnset 1, YAWN
	learnset 22, ANCIENTPOWER
	learnset 29, ROCK_SLIDE
	learnset 36, AMNESIA
	learnset 43, BODY_SLAM
	learnset 47, RECOVER
	learnset 54, FLAMETHROWER
	evos_attacks Swinub
	evo_data EVOLVE_LEVEL, 33, PILOSWINE
	learnset 1, TACKLE
	learnset 1, FORESIGHT ; Odor Sleuth → similar move
	learnset 5, BITE ; Mud Sport → egg move
	learnset 8, ICE_SHARD ; Powder Snow → Ice Shard
	learnset 11, MUD_SLAP
	learnset 14, ENDURE
	learnset 18, MAGNITUDE ; Mud Bomb → new move
	learnset 21, ICY_WIND
	learnset 24, ICICLE_CRASH ; Ice Shard → egg move
	learnset 28, TAKE_DOWN
	learnset 35, BULLDOZE ; Mist → TM move
	learnset 37, REVERSAL ; Earthquake → similar move
	learnset 40, EARTHQUAKE ; Flail → Earthquake
	learnset 44, BLIZZARD
	learnset 48, AMNESIA

	evos_attacks Piloswine
	evo_data EVOLVE_MOVE, ANCIENTPOWER, MAMOSWINE
	learnset 1, ANCIENTPOWER
	learnset 1, FURY_STRIKES ; evolution move (Fury Attack)
	learnset 1, PECK
	learnset 1, FORESIGHT ; Odor Sleuth → similar move
	learnset 5, BITE ; Mud Sport → egg move
	learnset 8, ICE_SHARD ; Powder Snow → Ice Shard
	learnset 11, MUD_SLAP
	learnset 14, ENDURE
	learnset 18, MAGNITUDE ; Mud Bomb → new move
	learnset 21, ICY_WIND
	learnset 24, ICICLE_CRASH ; Ice Fang → egg move
	learnset 28, TAKE_DOWN
	learnset 37, BULLDOZE ; Mist → TM move
	learnset 41, THRASH
	learnset 46, EARTHQUAKE
	learnset 52, BLIZZARD
	learnset 58, AMNESIA

	evos_attacks CorsolaPlain
	learnset 1, TACKLE
	learnset 1, DEFENSE_CURL ; Harden → similar move
	learnset 4, WATER_GUN ; Bubble → similar move
	learnset 8, ROLLOUT ; Recover → TM move
	learnset 10, BUBBLE_BEAM
	learnset 13, SAFEGUARD ; Refresh → egg move
	learnset 17, ANCIENTPOWER
	learnset 20, ICICLE_SPEAR ; Spike Cannon → egg move
	learnset 23, CONFUSE_RAY ; Lucky Chant → egg move
	learnset 27, ENDURE ; Brine → Endure
	learnset 29, BARRIER ; Iron Defense → similar move
	learnset 31, ROCK_BLAST
	learnset 35, RECOVER ; Endure → Recover
	learnset 38, HYDRO_PUMP ; Aqua Ring → Sw/Sh move
	learnset 41, POWER_GEM
	learnset 45, MIRROR_COAT
	learnset 47, EARTH_POWER
	learnset 50, REVERSAL ; Flail → similar move

	evos_attacks CorsolaGalarian
	evo_data EVOLVE_LEVEL, 38, CURSOLA, PLAIN_FORM
	learnset 1, TACKLE
	learnset 1, DEFENSE_CURL ; Harden → similar move
	learnset 5, ASTONISH
	learnset 10, DISABLE
	learnset 15, HAZE ; Spite → egg move
	learnset 20, ANCIENTPOWER
	learnset 25, HEX
	learnset 30, CURSE
	learnset 35, GIGA_DRAIN ; Strength Sap → TM move
	learnset 40, POWER_GEM
	learnset 45, NIGHT_SHADE
	learnset 50, HYDRO_PUMP ; Grudge → TR move
	learnset 55, MIRROR_COAT

	evos_attacks Remoraid
	evo_data EVOLVE_LEVEL, 25, OCTILLERY
	learnset 1, WRAP ; Sw/Sh move
	learnset 1, WATER_GUN
	learnset 6, FORESIGHT ; Lock-On → new move
	learnset 10, PSYBEAM
	learnset 14, AURORA_BEAM
	learnset 18, BUBBLE_BEAM
	learnset 22, BULK_UP
	learnset 26, WATER_PULSE
	learnset 30, FLAMETHROWER ; Signal Beam → TM move
	learnset 34, ICE_BEAM
	learnset 38, SEED_BOMB ; Bullet Seed → tutor move
	learnset 42, GUNK_SHOT ; Hydro Pump → new move
	learnset 46, HYDRO_PUMP ; Hyper Beam → Hydro Pump
	learnset 50, AURA_SPHERE ; Soak → new move
	learnset 54, HYPER_BEAM

	evos_attacks Octillery
	learnset 1, WATER_PULSE ; evolution move
	learnset 1, ROCK_BLAST
	learnset 1, POWER_WHIP ; new move
	learnset 1, WATER_GUN
	learnset 6, FORESIGHT ; Constrict → new move
	learnset 10, PSYBEAM
	learnset 14, AURORA_BEAM
	learnset 18, BUBBLE_BEAM
	learnset 22, BULK_UP
	learnset 26, WRAP ; Wring Out → new move
	learnset 28, WATER_PULSE
	learnset 34, FLAMETHROWER ; Signal Beam → TM move
	learnset 40, ICE_BEAM
	learnset 46, SEED_BOMB ; Bullet Seed → tutor move
	learnset 52, GUNK_SHOT ; Hydro Pump → new move
	learnset 58, HYDRO_PUMP ; Hyper Beam → Hydro Pump
if !DEF(FAITHFUL)
	learnset 58, FIRE_BLAST ; new move
endc
	learnset 64, AURA_SPHERE ; Soak → new move
	learnset 70, HYPER_BEAM

	evos_attacks Delibird
; based on Gen V Chatot
	learnset 1, PECK
	learnset 5, GROWL
	learnset 9, PAY_DAY ; Mirror Move → new move
	learnset 13, SING
	learnset 17, ICY_WIND
	learnset 21, WING_ATTACK
	learnset 25, HAIL
	learnset 29, DRILL_PECK
	learnset 33, AURORA_BEAM
	learnset 37, BODY_SLAM
	learnset 41, ROOST
	learnset 45, FLY
	learnset 49, BELLY_DRUM
	learnset 53, HURRICANE
	learnset 57, BLIZZARD

	evos_attacks Mantine
	learnset 1, GUST ; event move
	learnset 1, TACKLE
	learnset 1, WATER_GUN ; Bubble → similar move
	learnset 3, SUPERSONIC
	learnset 7, BUBBLE_BEAM
	learnset 11, CONFUSE_RAY
	learnset 14, WING_ATTACK
	learnset 16, HEADBUTT
	learnset 19, WATER_PULSE
	learnset 23, AQUA_JET ; Wide Guard → new move
	learnset 27, TAKE_DOWN
	learnset 32, AGILITY
	learnset 36, AIR_SLASH
	learnset 39, ROOST ; Aqua Ring → similar move
	learnset 46, MIRROR_COAT ; Bounce → Dream World move
	learnset 49, HYDRO_PUMP

	evos_attacks Skarmory
	learnset 1, LEER
	learnset 1, PECK
	learnset 12, METAL_CLAW
	learnset 16, AGILITY
	learnset 20, WING_ATTACK
	learnset 24, SLASH
	learnset 28, STEEL_WING
	learnset 36, DRILL_PECK
	learnset 44, SPIKES
	learnset 52, BRAVE_BIRD
	evos_attacks Houndour
	evo_data EVOLVE_LEVEL, 24, HOUNDOOM
	learnset 1, EMBER
	learnset 1, LEER
	learnset 13, ROAR
	learnset 16, BITE
	learnset 32, TORMENT
	learnset 44, FLAMETHROWER
	learnset 49, CRUNCH
	learnset 52, NASTY_PLOT
	evos_attacks Houndoom
	learnset 1, EMBER
	learnset 1, LEER
	learnset 1, NASTY_PLOT
	learnset 13, ROAR
	learnset 16, BITE
	learnset 35, TORMENT
	learnset 50, FLAMETHROWER
	learnset 56, CRUNCH
	evos_attacks Kingdra
	learnset 1, LEER
	learnset 1, SMOKESCREEN
	learnset 1, WATER_GUN
	learnset 1, YAWN
	learnset 20, DRAGONBREATH
	learnset 25, BUBBLE_BEAM
	learnset 30, AGILITY
	learnset 37, WATER_PULSE
	learnset 44, DRAGON_PULSE
	learnset 51, HYDRO_PUMP
	learnset 58, DRAGON_DANCE
	learnset 65, RAIN_DANCE
	evos_attacks Phanpy
	evo_data EVOLVE_LEVEL, 25, DONPHAN
	learnset 1, DEFENSE_CURL
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 10, ROLLOUT
	learnset 15, BULLDOZE
	learnset 19, ENDURE
	learnset 28, TAKE_DOWN
	learnset 33, CHARM
	learnset 42, DOUBLE_EDGE
	evos_attacks Donphan
	learnset 1, BULLDOZE
	learnset 1, DEFENSE_CURL
	learnset 1, GROWL
	learnset 1, HORN_ATTACK
	learnset 6, RAPID_SPIN
	learnset 10, ROLLOUT
	learnset 19, KNOCK_OFF
	learnset 37, SCARY_FACE
	learnset 43, EARTHQUAKE
	learnset 50, GIGA_IMPACT
	evos_attacks Porygon2
	evo_data EVOLVE_TRADE, DUBIOUS_DISC, PORYGON_Z
	learnset 1, CONVERSION
	learnset 1, DEFENSE_CURL
	learnset 1, TACKLE
	learnset 15, THUNDERSHOCK
	learnset 20, PSYBEAM
	learnset 30, AGILITY
	learnset 35, RECOVER
	learnset 45, TRI_ATTACK
	learnset 60, HYPER_BEAM
	evos_attacks Stantler
	evo_data EVOLVE_LOCATION, RUGGED_ROAD, WYRDEER
	evo_data EVOLVE_LOCATION, SNOWTOP_MOUNTAIN, WYRDEER
	evo_data EVOLVE_LOCATION, SINJOH_RUINS, WYRDEER
	evo_data EVOLVE_LOCATION, MYSTRI_STAGE, WYRDEER
	learnset 1, TACKLE
	learnset 3, LEER
	learnset 7, ASTONISH
	learnset 10, HYPNOSIS
	learnset 13, STOMP
	learnset 16, MUD_SLAP ; Sand-Attack → similar move
	learnset 21, HEADBUTT ; Take Down → tutor move
	learnset 23, CONFUSE_RAY
	learnset 27, CALM_MIND
	learnset 33, TAKE_DOWN ; Role Play → Take Down
	learnset 38, ZEN_HEADBUTT
	learnset 43, THRASH ; Jump Kick → egg move
	learnset 49, SKILL_SWAP ; Imprison → tutor move
	learnset 50, HI_JUMP_KICK ; Captivate → new move
	learnset 55, MEGAHORN ; Me First → egg move
	learnset 60, DOUBLE_EDGE ; new move

	evos_attacks Smeargle
	learnset 1, SKETCH
	learnset 11, SKETCH
	learnset 21, SKETCH
	learnset 31, SKETCH
	learnset 41, SKETCH
	learnset 51, SKETCH
	learnset 61, SKETCH
	learnset 71, SKETCH
	learnset 81, SKETCH
	learnset 91, SKETCH

	evos_attacks Tyrogue
	evo_data EVOLVE_STAT, 20, ATK_LT_DEF, HITMONCHAN
	evo_data EVOLVE_STAT, 20, ATK_GT_DEF, HITMONLEE
	evo_data EVOLVE_STAT, 20, ATK_EQ_DEF, HITMONTOP
	learnset 1, FAKE_OUT
	learnset 1, TACKLE
	learnset 6, QUICK_ATTACK
	learnset 11, MACH_PUNCH
	learnset 16, FOCUS_ENERGY
	evos_attacks Hitmontop
	learnset 1, FAKE_OUT
	learnset 1, TACKLE
	learnset 4, QUICK_ATTACK
	learnset 8, GYRO_BALL
	learnset 16, RAPID_SPIN
	learnset 20, FEINT
	learnset 24, SUCKER_PUNCH
	learnset 28, AGILITY
	learnset 32, DIG
	learnset 36, CLOSE_COMBAT
	learnset 40, COUNTER
	evos_attacks Smoochum
	evo_data EVOLVE_LEVEL, 30, JYNX
	learnset 1, LICK
	learnset 1, TACKLE ; Pound → similar move
	learnset 4, ICY_WIND ; Powder Snow → TM move
	learnset 8, METRONOME ; Copycat → Jynx RBY TM move
	learnset 12, CONFUSION
	learnset 16, THIEF ; Covet → similar move
	learnset 20, SING
	learnset 24, MEAN_LOOK ; Fake Tears → Mean Look
	learnset 28, ICE_PUNCH
	learnset 32, PSYCHIC_M
	learnset 36, SWEET_KISS
	learnset 40, NASTY_PLOT ; Mean Look → egg move
	learnset 44, PERISH_SONG
	learnset 48, BLIZZARD

	evos_attacks Elekid
	evo_data EVOLVE_LEVEL, 30, ELECTABUZZ
	learnset 1, LEER
	learnset 1, QUICK_ATTACK
	learnset 4, THUNDERSHOCK
	learnset 12, SWIFT
	learnset 20, THUNDER_WAVE
	learnset 24, SCREECH
	learnset 28, THUNDERPUNCH
	learnset 36, LOW_KICK
	learnset 40, THUNDERBOLT
	learnset 44, LIGHT_SCREEN
	learnset 48, THUNDER
	evos_attacks Magby
	evo_data EVOLVE_LEVEL, 30, MAGMAR
	learnset 1, LEER
	learnset 4, EMBER
	learnset 8, SMOKESCREEN
	learnset 20, CONFUSE_RAY
	learnset 24, SCARY_FACE
	learnset 28, FIRE_PUNCH
	learnset 36, LOW_KICK
	learnset 40, FLAMETHROWER
	learnset 44, SUNNY_DAY
	learnset 48, FIRE_BLAST
	evos_attacks Miltank
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 5, ROLLOUT
	learnset 10, DEFENSE_CURL
	learnset 15, STOMP
	learnset 20, HEAL_BELL
	learnset 25, HEADBUTT
	learnset 30, ZEN_HEADBUTT
	learnset 40, BODY_SLAM
	learnset 45, PLAY_ROUGH
	learnset 50, CHARM
	evos_attacks Blissey
	learnset 1, CHARM
	learnset 1, DEFENSE_CURL
	learnset 1, DISARM_VOICE
	learnset 1, SWEET_KISS
	learnset 16, SING
	learnset 24, TAKE_DOWN
	learnset 36, LIGHT_SCREEN
	learnset 40, DOUBLE_EDGE
	evos_attacks Raikou
	learnset 1, BITE
	learnset 1, LEER
	learnset 8, THUNDERSHOCK
	learnset 15, ROAR
	learnset 22, QUICK_ATTACK
	learnset 29, SPARK
	learnset 36, REFLECT
	learnset 43, CRUNCH
	learnset 50, WILD_CHARGE ; Thunder Fang → TM move
	learnset 57, EXTREMESPEED ; Discharge → event move
	learnset 64, EXTRASENSORY
	learnset 71, RAIN_DANCE
	learnset 78, CALM_MIND
	learnset 85, AURA_SPHERE ; Thunder → event move
	learnset 92, THUNDER
	learnset 99, HIDDEN_POWER ; TM move

	evos_attacks Entei
	learnset 1, BITE
	learnset 1, LEER
	learnset 8, EMBER
	learnset 15, ROAR
	learnset 22, FIRE_SPIN
	learnset 29, STOMP
	learnset 36, FLAMETHROWER
	learnset 43, SWAGGER
	learnset 50, FLAME_CHARGE ; Fire Fang → TM move
	learnset 57, EXTREMESPEED ; Lava Plume → event move
	learnset 64, EXTRASENSORY
	learnset 71, FIRE_BLAST
	learnset 78, CALM_MIND
	learnset 85, FLARE_BLITZ ; Eruption → event move
	learnset 92, FLARE_BLITZ
	learnset 99, HIDDEN_POWER ; TM move

	evos_attacks Suicune
	learnset 1, BITE
	learnset 1, LEER
	learnset 8, BUBBLE_BEAM
	learnset 15, RAIN_DANCE
	learnset 22, GUST
	learnset 29, AURORA_BEAM
	learnset 36, LIGHT_SCREEN ; Mist → new move
	learnset 43, MIRROR_COAT
	learnset 50, AIR_SLASH ; Ice Fang → event move
	learnset 57, TAILWIND ; Tailwind
	learnset 64, EXTRASENSORY
	learnset 71, HYDRO_PUMP
	learnset 78, CALM_MIND
	learnset 85, HYPER_BEAM ; Blizzard → TM move
	learnset 92, BLIZZARD
	learnset 99, HIDDEN_POWER ; TM move

	evos_attacks Larvitar
	evo_data EVOLVE_LEVEL, 30, PUPITAR
	learnset 1, LEER
	learnset 1, TACKLE
	learnset 3, ROCK_THROW
	learnset 9, ROCK_TOMB
	learnset 9, BITE
	learnset 12, SCARY_FACE
	learnset 15, ROCK_SLIDE
	learnset 21, SCREECH
	learnset 27, CRUNCH
	learnset 31, EARTHQUAKE
	learnset 33, STONE_EDGE
	learnset 36, THRASH
	learnset 39, SANDSTORM
	learnset 42, HYPER_BEAM
	evos_attacks Pupitar
	evo_data EVOLVE_LEVEL, 55, TYRANITAR
	learnset 1, LEER
	learnset 1, ROCK_THROW
	learnset 1, TACKLE
	learnset 9, BITE
	learnset 12, SCARY_FACE
	learnset 15, ROCK_SLIDE
	learnset 21, SCREECH
	learnset 27, CRUNCH
	learnset 33, EARTHQUAKE
	learnset 37, STONE_EDGE
	learnset 42, THRASH
	learnset 47, SANDSTORM
	learnset 52, HYPER_BEAM
	evos_attacks Tyranitar
	learnset 1, DARK_PULSE
	learnset 1, LEER
	learnset 1, ROCK_THROW
	learnset 1, TACKLE
	learnset 9, BITE
	learnset 12, SCARY_FACE
	learnset 15, ROCK_SLIDE
	learnset 21, SCREECH
	learnset 27, CRUNCH
	learnset 33, EARTHQUAKE
	learnset 37, STONE_EDGE
	learnset 42, THRASH
	learnset 47, SANDSTORM
	learnset 52, HYPER_BEAM
	learnset 59, GIGA_IMPACT
	evos_attacks Lugia
	learnset 1, ROAR ; Whirlwind → similar move
	learnset 9, GUST
	learnset 15, DRAGONBREATH ; Dragon Rush → GSC TM move
	learnset 23, EXTRASENSORY
	learnset 29, RAIN_DANCE
	learnset 37, HYDRO_PUMP
	learnset 43, DRAGON_PULSE ; Aeroblast → TM move
	learnset 50, HURRICANE ; Punishment → Aeroblast
	learnset 57, ANCIENTPOWER
	learnset 65, SAFEGUARD
	learnset 71, RECOVER
	learnset 79, FUTURE_SIGHT
	learnset 85, REFLECT ; Natural Gift → TM move
	learnset 93, CALM_MIND
	learnset 99, HURRICANE ; Sky Attack → new move

	evos_attacks HoOh
	learnset 1, ROAR ; Whirlwind → similar move
	learnset 9, GUST
	learnset 15, DRAGONBREATH ; Brave Bird → GSC TM move
	learnset 23, EXTRASENSORY
	learnset 29, SUNNY_DAY
	learnset 37, FIRE_BLAST
	learnset 43, SOLAR_BEAM ; Sacred Fire → Solar Beam
	learnset 50, FLARE_BLITZ ; Punishment → Sacred Fire
	learnset 57, ANCIENTPOWER
	learnset 65, SAFEGUARD
	learnset 71, RECOVER
	learnset 79, FUTURE_SIGHT
	learnset 85, LIGHT_SCREEN ; Natural Gift → TM move
	learnset 93, CALM_MIND
	learnset 99, BRAVE_BIRD ; Sky Attack → Brave Bird

	evos_attacks Celebi
	learnset 1, LEECH_SEED
	learnset 1, CONFUSION
	learnset 1, RECOVER
	learnset 1, METRONOME ; Heal Bell → new move
	learnset 10, SAFEGUARD
	learnset 19, ENERGY_BALL ; Magical Leaf → TM move
	learnset 28, ANCIENTPOWER
	learnset 37, BATON_PASS
	learnset 46, MOONBLAST ; Natural Gift → new move
	learnset 55, HEAL_BLOCK ; Heal Block
	learnset 64, FUTURE_SIGHT
	learnset 73, HEAL_BELL ; Healing Wish → Heal Bell
	learnset 82, NASTY_PLOT ; Leaf Storm → event move
	learnset 91, PERISH_SONG
	learnset 100, AURA_SPHERE ; Sw/Sh move

	evos_attacks Azurill
	evo_data EVOLVE_HAPPINESS, TR_ANYTIME, MARILL
	learnset 1, SPLASH
	learnset 1, WATER_GUN
	learnset 6, BUBBLE_BEAM
	learnset 9, CHARM
	evos_attacks Wynaut
	evo_data EVOLVE_LEVEL, 15, WOBBUFFET
	learnset 1, SPLASH
	learnset 1, CHARM
	learnset 1, ENCORE
	learnset 1, AMNESIA
	learnset 1, COUNTER
	learnset 1, MIRROR_COAT
	learnset 1, SAFEGUARD
	learnset 1, DESTINY_BOND

	evos_attacks Ambipom
	learnset 1, ASTONISH
	learnset 1, SCRATCH
	learnset 11, BATON_PASS
	learnset 18, FURY_STRIKES
	learnset 22, SWIFT
	learnset 25, SCREECH
	learnset 29, AGILITY
	learnset 39, NASTY_PLOT
	evos_attacks Mismagius
	learnset 1, ASTONISH
	learnset 1, GROWL
	learnset 1, POWER_GEM
	evos_attacks Honchkrow
	learnset 1, ASTONISH
	learnset 1, HAZE
	learnset 1, NIGHT_SLASH
	learnset 1, SUCKER_PUNCH
	learnset 1, WING_ATTACK
	learnset 25, SWAGGER
	learnset 35, NASTY_PLOT
	learnset 55, DARK_PULSE
	evos_attacks Bonsly
	evo_data EVOLVE_MOVE, ROCK_THROW, SUDOWOODO
	learnset 1, CHARM ; Fake Tears → new move
	learnset 1, SUBSTITUTE ; Copycat → Sudowoodo event move
	learnset 5, REVERSAL ; Flail → similar move
	learnset 8, LOW_KICK
	learnset 12, LEER ; Rock Throw → new move
	learnset 15, ROCK_THROW ; Mimic → Rock Throw
	learnset 19, FEINT_ATTACK
	learnset 22, ANCIENTPOWER ; Rock Tomb → new move
	learnset 26, PROTECT ; Block → TM move
	learnset 29, ROCK_SLIDE
	learnset 33, COUNTER
	learnset 36, SUCKER_PUNCH
	learnset 40, DOUBLE_EDGE

	evos_attacks MimeJr
	evo_data EVOLVE_LOCATION, ICE_PATH, MR__MIME, GALARIAN_FORM
	evo_data EVOLVE_LEVEL, 30, MR__MIME, PLAIN_FORM
	evo_data EVOLVE_ITEM, ICE_STONE, MR__MIME, GALARIAN_FORM
	learnset 1, BARRIER
	learnset 1, CONFUSION
	learnset 1, TACKLE  ; Pound → similar move
	learnset 4, HYPNOSIS ; Copycat → egg move
	learnset 8, CALM_MIND ; Meditate → TM move
	learnset 11, DOUBLE_SLAP
	learnset 13, PROTECT ; Mimic → event move
	learnset 15, METRONOME ; Psywave → RBY TM move
	learnset 18, ENCORE
	learnset 22, LIGHT_SCREEN
	learnset 22, REFLECT
	learnset 25, PSYBEAM
	learnset 29, SUBSTITUTE
	learnset 32, CONFUSE_RAY ; Recycle → egg move
	learnset 36, TRICK
	learnset 39, PSYCHIC_M
	learnset 43, FUTURE_SIGHT ; Role Play → egg move
	learnset 46, BATON_PASS
	learnset 50, SAFEGUARD

	evos_attacks Happiny
	evo_data EVOLVE_HOLDING, OVAL_STONE, TR_MORNDAY, CHANSEY
	learnset 4, DEFENSE_CURL
	learnset 8, SWEET_KISS
	learnset 12, DISARM_VOICE
	learnset 20, CHARM
	evos_attacks Munchlax
	evo_data EVOLVE_HAPPINESS, TR_ANYTIME, SNORLAX
	learnset 1, SWEET_KISS ; Recycle → event move
	learnset 1, METRONOME
	learnset 1, TACKLE
	learnset 4, DEFENSE_CURL
	learnset 9, AMNESIA
	learnset 12, LICK
	learnset 17, RAGE ; Chip Away → RBY TM move
	learnset 20, TAKE_DOWN ; Screech → RBY TM move
	learnset 25, BODY_SLAM
	learnset 28, SCREECH ; Stockpile → Screech
	learnset 33, PROTECT ; Swallow → TM move
	learnset 36, ROLLOUT
	learnset 41, OUTRAGE ; Fling → HGSS tutor move
	learnset 44, BELLY_DRUM
	learnset 49, CRUNCH ; Natural Gift → Snorlax move
	learnset 50, GUNK_SHOT ; Snatch → egg move
	learnset 57, DOUBLE_EDGE ; Last Resort → egg move

	evos_attacks Mantyke
	evo_data EVOLVE_PARTY, REMORAID, MANTINE
	learnset 1, GUST ; event move
	learnset 1, TACKLE
	learnset 1, WATER_GUN ; Bubble → similar move
	learnset 3, SUPERSONIC
	learnset 7, BUBBLE_BEAM
	learnset 11, CONFUSE_RAY
	learnset 14, WING_ATTACK
	learnset 16, HEADBUTT
	learnset 19, WATER_PULSE
	learnset 23, AQUA_JET ; Wide Guard → new move
	learnset 27, TAKE_DOWN
	learnset 32, AGILITY
	learnset 36, AIR_SLASH
	learnset 39, ROOST ; Aqua Ring → similar move
	learnset 46, MIRROR_COAT ; Bounce → Dream World move
	learnset 49, HYDRO_PUMP

	evos_attacks Weavile
	learnset 1, AGILITY
	learnset 1, ICE_SHARD
	learnset 1, LEER
	learnset 1, QUICK_ATTACK
	learnset 1, SCRATCH
	learnset 1, SLASH
	learnset 1, TAUNT
	learnset 18, METAL_CLAW
	learnset 24, ICY_WIND
	learnset 30, FURY_STRIKES
	learnset 36, HONE_CLAWS
	learnset 48, NASTY_PLOT
	learnset 54, SCREECH
	learnset 60, NIGHT_SLASH
	learnset 66, DARK_PULSE
	evos_attacks Magnezone
	learnset 1, MIRROR_COAT
	learnset 1, SUPERSONIC
	learnset 1, TACKLE
	learnset 1, THUNDERSHOCK
	learnset 1, THUNDER_WAVE
	learnset 1, TRI_ATTACK
	learnset 16, GYRO_BALL
	learnset 20, SPARK
	learnset 24, SCREECH
	learnset 34, FLASH_CANNON
	learnset 52, LIGHT_SCREEN
	evos_attacks Lickilicky
	learnset 1, DEFENSE_CURL
	learnset 1, LICK
	learnset 1, ROLLOUT
	learnset 1, SUPERSONIC
	learnset 18, WRAP
	learnset 24, DISABLE
	learnset 30, STOMP
	learnset 36, KNOCK_OFF
	learnset 42, SCREECH
	learnset 54, POWER_WHIP
	learnset 60, BELLY_DRUM
	evos_attacks Rhyperior
	learnset 1, BULLDOZE
	learnset 1, TACKLE
	learnset 15, HORN_ATTACK
	learnset 20, SCARY_FACE
	learnset 25, STOMP
	learnset 30, ROCK_BLAST
	learnset 40, TAKE_DOWN
	learnset 47, EARTHQUAKE
	learnset 54, STONE_EDGE
	learnset 61, MEGAHORN
	evos_attacks Tangrowth
	learnset 1, ABSORB
	learnset 1, GROWTH
	learnset 1, STUN_SPORE
	learnset 12, MEGA_DRAIN
	learnset 16, VINE_WHIP
	learnset 20, POISONPOWDER
	learnset 24, ANCIENTPOWER
	learnset 28, KNOCK_OFF
	learnset 32, GIGA_DRAIN
	learnset 36, SLEEP_POWDER
	learnset 48, POWER_WHIP
	evos_attacks Electivire
	learnset 1, LEER
	learnset 1, QUICK_ATTACK
	learnset 1, THUNDERSHOCK
	learnset 12, SWIFT
	learnset 20, THUNDER_WAVE
	learnset 24, SCREECH
	learnset 28, THUNDERPUNCH
	learnset 40, LOW_KICK
	learnset 46, THUNDERBOLT
	learnset 52, LIGHT_SCREEN
	learnset 58, THUNDER
	learnset 64, GIGA_IMPACT
	evos_attacks Magmortar
	learnset 1, EMBER
	learnset 1, LEER
	learnset 1, SMOKESCREEN
	learnset 20, CONFUSE_RAY
	learnset 24, SCARY_FACE
	learnset 28, FIRE_PUNCH
	learnset 40, LOW_KICK
	learnset 46, FLAMETHROWER
	learnset 52, SUNNY_DAY
	learnset 58, FIRE_BLAST
	learnset 64, HYPER_BEAM
	evos_attacks Togekiss
	learnset 0, AIR_SLASH
	learnset 1, ANCIENTPOWER
	learnset 1, AURA_SPHERE
	learnset 1, BATON_PASS
	learnset 1, CHARM
	learnset 1, DOUBLE_EDGE
	learnset 1, EXTREMESPEED
	learnset 1, GROWL
	learnset 1, METRONOME
	learnset 1, SAFEGUARD
	learnset 1, SWEET_KISS
	learnset 1, TRI_ATTACK
	learnset 1, YAWN
	evos_attacks Yanmega
	learnset 1, DRAGONBREATH ; evolution move
	learnset 1, NIGHT_SLASH
	learnset 1, TACKLE
	learnset 1, FORESIGHT
	learnset 1, BUG_BITE
	learnset 6, QUICK_ATTACK
	learnset 11, DOUBLE_TEAM
	learnset 14, SONIC_BOOM
	learnset 17, PROTECT ; Detect → similar move
	learnset 22, DRAGON_RAGE ; Supersonic → new move
	learnset 27, SUPERSONIC ; Uproar → Supersonic
	learnset 30, PURSUIT
if DEF(FAITHFUL)
	learnset 33, ANCIENTPOWER
else
	learnset 35, ANCIENTPOWER
endc
	learnset 38, FEINT
	learnset 43, WING_ATTACK ; Slash → Wing Attack
	learnset 46, SCREECH
	learnset 49, U_TURN
	learnset 54, AIR_SLASH
	learnset 57, BUG_BUZZ
	learnset 62, FLY ; new move

	evos_attacks Leafeon
	learnset 0, RAZOR_LEAF
	learnset 1, BATON_PASS
	learnset 1, BITE
	learnset 1, CHARM
	learnset 1, DOUBLE_EDGE
	learnset 1, GROWL
	learnset 1, SWIFT
	learnset 1, TACKLE
	learnset 1, TAKE_DOWN
	learnset 10, QUICK_ATTACK
	learnset 20, LEECH_SEED
	learnset 35, SUNNY_DAY
	learnset 40, GIGA_DRAIN
	learnset 45, SWORDS_DANCE
	evos_attacks Glaceon
	learnset 0, ICY_WIND
	learnset 1, BATON_PASS
	learnset 1, CHARM
	learnset 1, DOUBLE_EDGE
	learnset 1, GROWL
	learnset 1, SWIFT
	learnset 1, TACKLE
	learnset 1, TAKE_DOWN
	learnset 10, QUICK_ATTACK
	learnset 20, ICE_SHARD
	learnset 25, BITE
	learnset 45, MIRROR_COAT
	learnset 50, BLIZZARD
	evos_attacks Mamoswine
	learnset 1, ANCIENTPOWER
	learnset 1, PECK
	learnset 1, FORESIGHT ; Odor Sleuth → similar move
	learnset 5, BITE ; Mud Sport → egg move
	learnset 8, ICE_SHARD ; Powder Snow → Ice Shard
	learnset 11, MUD_SLAP
	learnset 14, ENDURE
	learnset 18, MAGNITUDE ; Mud Bomb → new move
	learnset 21, HAIL
	learnset 24, AVALANCHE ; Ice Fang → egg move
	learnset 28, TAKE_DOWN
	learnset 34, ROCK_BLAST ; Double Hit → Sw/Sh move
	learnset 37, BULLDOZE ; Mist → TM move
	learnset 41, THRASH
	learnset 46, EARTHQUAKE
	learnset 52, BLIZZARD
	learnset 58, SCARY_FACE

	evos_attacks PorygonZ
	learnset 1, CONVERSION
	learnset 1, DEFENSE_CURL
	learnset 1, NASTY_PLOT
	learnset 1, TACKLE
	learnset 1, TRICK_ROOM
	learnset 15, THUNDERSHOCK
	learnset 20, PSYBEAM
	learnset 30, AGILITY
	learnset 35, RECOVER
	learnset 45, TRI_ATTACK
	learnset 50, DOUBLE_EDGE
	learnset 65, HYPER_BEAM
	evos_attacks Sylveon
	learnset 0, DISARM_VOICE
	learnset 1, BATON_PASS
	learnset 1, BITE
	learnset 1, CHARM
	learnset 1, DOUBLE_EDGE
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 1, TAKE_DOWN
	learnset 10, QUICK_ATTACK
	learnset 20, SWIFT
	learnset 25, LIGHT_SCREEN
	learnset 30, DRAINING_KISS
	learnset 40, SKILL_SWAP
	learnset 50, MOONBLAST
	evos_attacks Perrserker
	learnset 1, IRON_HEAD ; evolution move
	learnset 1, COUNTER ; Metal Burst → similar move
	learnset 1, PLAY_ROUGH ; Iron Defense → TR move
	learnset 1, FAKE_OUT
	learnset 1, GROWL
	learnset 1, HONE_CLAWS
	learnset 1, SCRATCH
	learnset 12, PAY_DAY
	learnset 16, METAL_CLAW
	learnset 20, PURSUIT ; Taunt → new move
	learnset 24, SWAGGER
	learnset 31, FURY_STRIKES
	learnset 36, SCREECH
	learnset 42, SLASH
	learnset 48, CRUNCH ; Metal Sound → TR move
	learnset 54, THRASH
	learnset 60, CLOSE_COMBAT ; TR move

	evos_attacks Cursola
	learnset 1, PERISH_SONG
	learnset 1, TACKLE
	learnset 1, DEFENSE_CURL ; Harden → similar move
	learnset 1, ASTONISH
	learnset 1, DISABLE
	learnset 15, HAZE ; Spite → egg move
	learnset 20, ANCIENTPOWER
	learnset 25, HEX
	learnset 30, CURSE
	learnset 35, GIGA_DRAIN ; Strength Sap → TM move
	learnset 40, POWER_GEM
	learnset 45, NIGHT_SHADE
	learnset 50, HYDRO_PUMP ; Grudge → TR move
	learnset 55, MIRROR_COAT

	evos_attacks SirfetchD
	learnset 1, CUT ; Fury Cutter → HM move
	learnset 1, COUNTER ; Iron Defense → egg move ; evolution move
	learnset 1, QUICK_ATTACK ; First Impression → egg move
	learnset 1, PECK
	learnset 1, MUD_SLAP ; Sand Attack → similar move
	learnset 1, LEER
if DEF(FAITHFUL)
	learnset 15, BRICK_BREAK
else
	learnset 15, REVERSAL ; Rock Smash → TM move
endc
	learnset 20, FEINT_ATTACK ; Brutal Swing → similar move
	learnset 25, PROTECT ; Detect → similar move
	learnset 30, KNOCK_OFF
	learnset 35, STEEL_WING ; Defog → TM move
if DEF(FAITHFUL)
	learnset 40, NIGHT_SLASH ; Brick Break → egg move
else
	learnset 40, BRICK_BREAK
endc
	learnset 45, SWORDS_DANCE
	learnset 50, BODY_SLAM ; Slam → TR move
	learnset 55, POISON_JAB ; Leaf Blade → TR move
	learnset 60, CLOSE_COMBAT ; Final Gambit → TR move
	learnset 65, BRAVE_BIRD
	learnset 70, GIGA_IMPACT ; Meteor Assault → similar move

	evos_attacks Madame
	learnset 1, SACRED_SWORD ; evolution move
	learnset 1, CUT ; Fury Cutter → HM move
	learnset 1, COUNTER ; Iron Defense → egg move
	learnset 1, QUICK_ATTACK ; First Impression → egg move
	learnset 1, PECK
	learnset 1, MUD_SLAP ; Sand Attack → similar move
	learnset 1, LEER
if DEF(FAITHFUL)
	learnset 15, BRICK_BREAK
else
	learnset 15, REVERSAL ; Rock Smash → TM move
endc
	learnset 20, FEINT_ATTACK ; Brutal Swing → similar move
	learnset 25, PROTECT ; Detect → similar move
	learnset 30, KNOCK_OFF
	learnset 35, STEEL_WING ; Defog → TM move
if DEF(FAITHFUL)
	learnset 40, NIGHT_SLASH ; Brick Break → egg move
else
	learnset 40, BRICK_BREAK
endc
	learnset 45, SWORDS_DANCE
	learnset 50, BODY_SLAM ; Slam → TR move
	learnset 55, POISON_JAB ; Leaf Blade → TR move
	learnset 60, CLOSE_COMBAT ; Final Gambit → TR move
	learnset 65, BRAVE_BIRD
	learnset 70, GIGA_IMPACT ; Meteor Assault → similar move

	evos_attacks Ralts
	evo_data EVOLVE_LEVEL, 20, KIRLIA
	learnset 1, DISARM_VOICE
	learnset 1, GROWL
	learnset 3, DOUBLE_TEAM
	learnset 6, CONFUSION
	learnset 9, HYPNOSIS
	learnset 12, DRAINING_KISS
	learnset 15, TELEPORT
	learnset 18, PSYBEAM
	learnset 24, CHARM
	learnset 27, CALM_MIND
	learnset 30, PSYCHIC_M
	learnset 36, DREAM_EATER
	learnset 39, FUTURE_SIGHT
	evos_attacks Kirlia
	evo_data EVOLVE_LEVEL, 30, GARDEVOIR
	evo_data EVOLVE_ITEM, SHINY_STONE, GALLADE
	learnset 1, CONFUSION
	learnset 1, DISARM_VOICE
	learnset 1, DOUBLE_TEAM
	learnset 1, GROWL
	learnset 9, HYPNOSIS
	learnset 12, DRAINING_KISS
	learnset 15, TELEPORT
	learnset 18, PSYBEAM
	learnset 28, CHARM
	learnset 33, CALM_MIND
	learnset 38, PSYCHIC_M
	learnset 48, DREAM_EATER
	learnset 53, FUTURE_SIGHT
	evos_attacks Gardevoir
	learnset 1, CHARM
	learnset 1, CONFUSION
	learnset 1, DISARM_VOICE
	learnset 1, DOUBLE_TEAM
	learnset 1, GROWL
	learnset 9, HYPNOSIS
	learnset 12, DRAINING_KISS
	learnset 15, TELEPORT
	learnset 18, PSYBEAM
	learnset 35, CALM_MIND
	learnset 42, PSYCHIC_M
	learnset 49, MOONBLAST
	learnset 56, DREAM_EATER
	learnset 63, FUTURE_SIGHT
	evos_attacks Gallade
	learnset 0, SLASH
	learnset 1, CALM_MIND
	learnset 1, CHARM
	learnset 1, CONFUSION
	learnset 1, DISARM_VOICE
	learnset 1, DOUBLE_TEAM
	learnset 1, DRAINING_KISS
	learnset 1, DREAM_EATER
	learnset 1, FUTURE_SIGHT
	learnset 1, GROWL
	learnset 1, HYPNOSIS
	learnset 1, LEER
	learnset 1, NIGHT_SLASH
	learnset 1, PSYBEAM
	learnset 1, PSYCHIC_M
	learnset 1, SACRED_SWORD
	learnset 15, TELEPORT
	learnset 18, AERIAL_ACE
	learnset 23, FALSE_SWIPE
	learnset 28, PROTECT
	learnset 35, SWORDS_DANCE
	learnset 63, CLOSE_COMBAT
	evos_attacks Poochyena
	evo_data EVOLVE_LEVEL, 18, MIGHTYENA
	learnset 1, TACKLE
	learnset 10, BITE
	learnset 13, LEER
	learnset 16, ROAR
	learnset 19, SWAGGER
	learnset 25, SCARY_FACE
	learnset 28, TAUNT
	learnset 31, CRUNCH
	learnset 34, YAWN
	learnset 36, TAKE_DOWN
	learnset 40, SUCKER_PUNCH
	learnset 44, PLAY_ROUGH
	evos_attacks Mightyena
	learnset 1, BITE
	learnset 1, CRUNCH
	learnset 1, TACKLE
	learnset 1, THIEF
	learnset 13, LEER
	learnset 16, ROAR
	learnset 20, SWAGGER
	learnset 28, SCARY_FACE
	learnset 36, TAUNT
	learnset 44, YAWN
	learnset 48, TAKE_DOWN
	learnset 52, SUCKER_PUNCH
	learnset 56, PLAY_ROUGH
	evos_attacks Zigzagoon
	evo_data EVOLVE_LEVEL, 20, LINOONE
	learnset 1, GROWL
	learnset 1, TACKLE
	learnset 12, HEADBUTT
	learnset 18, PIN_MISSILE
	learnset 21, REST
	learnset 24, TAKE_DOWN
	learnset 33, BELLY_DRUM
	learnset 36, DOUBLE_EDGE
	evos_attacks Linoone
	learnset 0, SLASH
	learnset 1, GROWL
	learnset 1, PIN_MISSILE
	learnset 1, TACKLE
	learnset 12, HEADBUTT
	learnset 15, HONE_CLAWS
	learnset 18, FURY_STRIKES
	learnset 23, REST
	learnset 28, TAKE_DOWN
	learnset 43, BELLY_DRUM
	learnset 48, DOUBLE_EDGE
	evos_attacks Aron
	evo_data EVOLVE_LEVEL, 32, LAIRON
	learnset 1, TACKLE
	learnset 4, METAL_CLAW
	learnset 8, ROCK_TOMB
	learnset 12, ROAR
	learnset 16, HEADBUTT
	learnset 20, PROTECT
	learnset 24, ROCK_SLIDE
	learnset 28, IRON_HEAD
	learnset 36, TAKE_DOWN
	learnset 44, IRON_TAIL
	learnset 56, DOUBLE_EDGE
	evos_attacks Lairon
	evo_data EVOLVE_LEVEL, 42, AGGRON
	learnset 1, METAL_CLAW
	learnset 1, TACKLE
	learnset 12, ROAR
	learnset 16, HEADBUTT
	learnset 20, PROTECT
	learnset 24, ROCK_SLIDE
	learnset 28, IRON_HEAD
	learnset 40, TAKE_DOWN
	learnset 52, IRON_TAIL
	learnset 70, DOUBLE_EDGE
	evos_attacks Aggron
	learnset 1, METAL_CLAW
	learnset 1, TACKLE
	learnset 12, ROAR
	learnset 16, HEADBUTT
	learnset 20, PROTECT
	learnset 24, ROCK_SLIDE
	learnset 28, IRON_HEAD
	learnset 40, TAKE_DOWN
	learnset 56, IRON_TAIL
	learnset 80, DOUBLE_EDGE
	evos_attacks Trapinch
	evo_data EVOLVE_LEVEL, 35, VIBRAVA
	learnset 1, ASTONISH
	learnset 8, BITE
	learnset 12, MUD_SLAP
	learnset 20, BULLDOZE
	learnset 24, DIG
	learnset 28, CRUNCH
	learnset 32, SANDSTORM
	learnset 36, EARTH_POWER
	learnset 40, EARTHQUAKE
	evos_attacks Vibrava
	evo_data EVOLVE_LEVEL, 45, FLYGON
	learnset 0, DRAGONBREATH
	learnset 1, BITE
	learnset 1, DIG
	learnset 12, MUD_SLAP
	learnset 24, SCREECH
	learnset 28, BUG_BUZZ
	learnset 32, SANDSTORM
	learnset 38, EARTH_POWER
	learnset 44, EARTHQUAKE
	evos_attacks Flygon
	learnset 0, DRAGON_CLAW
	learnset 1, BULLDOZE
	learnset 1, DRAGONBREATH
	learnset 1, SUPERSONIC
	learnset 12, MUD_SLAP
	learnset 24, SCREECH
	learnset 28, BUG_BUZZ
	learnset 32, SANDSTORM
	learnset 38, EARTH_POWER
	learnset 44, EARTHQUAKE
	evos_attacks Cacnea
	evo_data EVOLVE_LEVEL, 32, CACTURNE
	learnset 1, LEER
	learnset 1, POISON_STING
	learnset 4, ABSORB
	learnset 7, GROWTH
	learnset 10, LEECH_SEED
	learnset 30, SPIKES
	learnset 34, SUCKER_PUNCH
	learnset 38, PIN_MISSILE
	learnset 42, ENERGY_BALL
	learnset 50, SANDSTORM
	learnset 54, DESTINY_BOND
	evos_attacks Cacturne
	learnset 1, ABSORB
	learnset 1, DESTINY_BOND
	learnset 1, GROWTH
	learnset 1, LEER
	learnset 1, POISON_STING
	learnset 10, LEECH_SEED
	learnset 30, SPIKES
	learnset 35, SUCKER_PUNCH
	learnset 38, PIN_MISSILE
	learnset 44, ENERGY_BALL
	learnset 54, SANDSTORM
	evos_attacks Baltoy
	evo_data EVOLVE_LEVEL, 36, CLAYDOL
	learnset 1, MUD_SLAP
	learnset 3, RAPID_SPIN
	learnset 6, CONFUSION
	learnset 15, PSYBEAM
	learnset 18, ANCIENTPOWER
	learnset 27, EXTRASENSORY
	learnset 30, EARTH_POWER
	learnset 39, SANDSTORM
	learnset 42, EXPLOSION
	evos_attacks Claydol
	learnset 0, HYPER_BEAM
	learnset 1, CONFUSION
	learnset 1, MUD_SLAP
	learnset 1, RAPID_SPIN
	learnset 1, TELEPORT
	learnset 15, PSYBEAM
	learnset 18, ANCIENTPOWER
	learnset 27, EXTRASENSORY
	learnset 30, EARTH_POWER
	learnset 43, SANDSTORM
	learnset 48, EXPLOSION
	evos_attacks Absol
	learnset 1, LEER
	learnset 1, QUICK_ATTACK
	learnset 5, DOUBLE_TEAM
	learnset 10, KNOCK_OFF
	learnset 20, TAUNT
	learnset 25, SLASH
	learnset 30, NIGHT_SLASH
	learnset 40, SUCKER_PUNCH
	learnset 45, SWORDS_DANCE
	learnset 50, FUTURE_SIGHT
	learnset 55, PERISH_SONG
	evos_attacks Bagon
	evo_data EVOLVE_LEVEL, 30, SHELGON
	learnset 1, EMBER
	learnset 1, LEER
	learnset 5, BITE
	learnset 10, DRAGONBREATH
	learnset 15, HEADBUTT
	learnset 20, SCARY_FACE
	learnset 25, CRUNCH
	learnset 31, DRAGON_CLAW
	learnset 35, ZEN_HEADBUTT
	learnset 45, FLAMETHROWER
	learnset 50, OUTRAGE
	learnset 55, DOUBLE_EDGE
	evos_attacks Shelgon
	evo_data EVOLVE_LEVEL, 50, SALAMENCE
	learnset 0, PROTECT
	learnset 1, BITE
	learnset 1, DRAGONBREATH
	learnset 1, EMBER
	learnset 1, LEER
	learnset 15, HEADBUTT
	learnset 20, SCARY_FACE
	learnset 25, CRUNCH
	learnset 33, DRAGON_CLAW
	learnset 39, ZEN_HEADBUTT
	learnset 53, FLAMETHROWER
	learnset 60, OUTRAGE
	learnset 67, DOUBLE_EDGE
	evos_attacks Salamence
	learnset 0, FLY
	learnset 1, BITE
	learnset 1, DRAGONBREATH
	learnset 1, EMBER
	learnset 1, LEER
	learnset 1, PROTECT
	learnset 1, ROOST
	learnset 15, HEADBUTT
	learnset 20, SCARY_FACE
	learnset 25, CRUNCH
	learnset 33, DRAGON_CLAW
	learnset 39, ZEN_HEADBUTT
	learnset 55, FLAMETHROWER
	learnset 73, DOUBLE_EDGE
	evos_attacks Beldum
	evo_data EVOLVE_LEVEL, 20, METANG
	learnset 1, TACKLE
	evos_attacks Metang
	evo_data EVOLVE_LEVEL, 45, METAGROSS
	learnset 0, CONFUSION
	learnset 0, METAL_CLAW
	learnset 1, BULLET_PUNCH
	learnset 1, HONE_CLAWS
	learnset 1, TACKLE
	learnset 6, ZEN_HEADBUTT
	learnset 18, FLASH_CANNON
	learnset 26, TAKE_DOWN
	learnset 34, PSYCHIC_M
	learnset 42, SCARY_FACE
	learnset 66, AGILITY
	learnset 74, HYPER_BEAM
	evos_attacks Metagross
	learnset 1, BULLET_PUNCH
	learnset 1, CONFUSION
	learnset 1, METAL_CLAW
	learnset 1, TACKLE
	learnset 6, ZEN_HEADBUTT
	learnset 16, FLASH_CANNON
	learnset 26, TAKE_DOWN
	learnset 34, PSYCHIC_M
	learnset 42, SCARY_FACE
	learnset 72, AGILITY
	learnset 82, HYPER_BEAM
	evos_attacks Shinx
	evo_data EVOLVE_LEVEL, 15, LUXIO
	learnset 1, LEER
	learnset 1, TACKLE
	learnset 4, THUNDERSHOCK
	learnset 12, BITE
	learnset 16, SPARK
	learnset 20, ROAR
	learnset 24, VOLT_SWITCH
	learnset 28, SCARY_FACE
	learnset 32, THUNDER_WAVE
	learnset 36, CRUNCH
	learnset 40, DISCHARGE
	learnset 44, SWAGGER
	learnset 48, WILD_CHARGE
	evos_attacks Luxio
	evo_data EVOLVE_LEVEL, 30, LUXRAY
	learnset 1, LEER
	learnset 1, TACKLE
	learnset 1, THUNDERSHOCK
	learnset 12, BITE
	learnset 18, SPARK
	learnset 24, ROAR
	learnset 31, VOLT_SWITCH
	learnset 36, SCARY_FACE
	learnset 42, THUNDER_WAVE
	learnset 48, DISCHARGE
	learnset 48, CRUNCH
	learnset 60, SWAGGER
	learnset 68, WILD_CHARGE
	evos_attacks Luxray
	learnset 1, LEER
	learnset 1, TACKLE
	learnset 1, THUNDERSHOCK
	learnset 12, BITE
	learnset 18, SPARK
	learnset 24, ROAR
	learnset 33, VOLT_SWITCH
	learnset 40, SCARY_FACE
	learnset 48, THUNDER_WAVE
	learnset 52, DISCHARGE
	learnset 56, CRUNCH
	learnset 72, SWAGGER
	learnset 80, WILD_CHARGE
	evos_attacks Stunky
	evo_data EVOLVE_LEVEL, 34, SKUNTANK
	learnset 1, SCRATCH
	learnset 6, SMOKESCREEN
	learnset 12, FURY_STRIKES
	learnset 18, BITE
	learnset 21, VENOSHOCK
	learnset 24, SCREECH
	learnset 27, TOXIC
	learnset 30, SUCKER_PUNCH
	learnset 36, NIGHT_SLASH
	learnset 42, EXPLOSION
	evos_attacks Skuntank
	learnset 0, FLAMETHROWER
	learnset 1, SCRATCH
	learnset 1, SMOKESCREEN
	learnset 12, FURY_STRIKES
	learnset 18, BITE
	learnset 21, VENOSHOCK
	learnset 24, SCREECH
	learnset 27, TOXIC
	learnset 30, SUCKER_PUNCH
	learnset 38, NIGHT_SLASH
	learnset 48, EXPLOSION
	evos_attacks Bronzor
	evo_data EVOLVE_LEVEL, 33, BRONZONG
	learnset 1, CONFUSION
	learnset 1, TACKLE
	learnset 4, CONFUSE_RAY
	learnset 16, GYRO_BALL
	learnset 20, HYPNOSIS
	learnset 24, SAFEGUARD
	learnset 28, EXTRASENSORY
	learnset 44, FUTURE_SIGHT
	evos_attacks Bronzong
	learnset 1, CONFUSE_RAY
	learnset 1, CONFUSION
	learnset 1, SUNNY_DAY
	learnset 1, TACKLE
	learnset 16, GYRO_BALL
	learnset 20, HYPNOSIS
	learnset 24, SAFEGUARD
	learnset 28, EXTRASENSORY
	learnset 50, FUTURE_SIGHT
	learnset 56, RAIN_DANCE
	evos_attacks Riolu
	evo_data EVOLVE_LEVEL, 25, LUCARIO
	learnset 1, ENDURE
	learnset 1, QUICK_ATTACK
	learnset 6, FOCUS_ENERGY
	learnset 8, METAL_CLAW
	learnset 12, COUNTER
	learnset 15, FEINT
	learnset 20, BRICK_BREAK
	learnset 28, SCREECH
	learnset 40, SWORDS_DANCE
	learnset 56, REVERSAL
	evos_attacks Lucario
	learnset 0, AURA_SPHERE
	learnset 1, FOCUS_ENERGY
	learnset 1, METAL_CLAW
	learnset 1, QUICK_ATTACK
	learnset 1, REVERSAL
	learnset 1, BRICK_BREAK
	learnset 1, SCREECH
	learnset 12, COUNTER
	learnset 15, FEINT
	learnset 24, CALM_MIND
	learnset 40, SWORDS_DANCE
	learnset 52, DRAGON_PULSE
	learnset 56, EXTREMESPEED
	learnset 60, CLOSE_COMBAT
	evos_attacks Skorupi
	evo_data EVOLVE_LEVEL, 40, DRAPION
	learnset 1, LEER
	learnset 1, POISON_STING
	learnset 3, HONE_CLAWS
	learnset 12, BITE
	learnset 15, TOXIC_SPIKES
	learnset 18, BUG_BITE
	learnset 21, VENOSHOCK
	learnset 24, KNOCK_OFF
	learnset 27, SCARY_FACE
	learnset 30, PIN_MISSILE
	learnset 33, TOXIC
	learnset 36, NIGHT_SLASH
	learnset 42, X_SCISSOR
	learnset 48, CRUNCH
	evos_attacks Drapion
	learnset 1, HONE_CLAWS
	learnset 1, LEER
	learnset 1, POISON_STING
	learnset 12, BITE
	learnset 15, TOXIC_SPIKES
	learnset 18, BUG_BITE
	learnset 21, VENOSHOCK
	learnset 24, KNOCK_OFF
	learnset 27, SCARY_FACE
	learnset 30, PIN_MISSILE
	learnset 33, TOXIC
	learnset 36, NIGHT_SLASH
	learnset 44, X_SCISSOR
	learnset 54, CRUNCH
	evos_attacks Croagunk
	evo_data EVOLVE_LEVEL, 37, TOXICROAK
	learnset 1, MUD_SLAP
	learnset 1, POISON_STING
	learnset 4, ASTONISH
	learnset 8, TAUNT
	learnset 16, LOW_KICK
	learnset 20, VENOSHOCK
	learnset 24, SUCKER_PUNCH
	learnset 28, SWAGGER
	learnset 32, POISON_JAB
	learnset 36, TOXIC
	learnset 40, NASTY_PLOT
	learnset 44, SLUDGE_BOMB
	evos_attacks Toxicroak
	learnset 1, ASTONISH
	learnset 1, MUD_SLAP
	learnset 1, POISON_STING
	learnset 1, TAUNT
	learnset 16, LOW_KICK
	learnset 20, VENOSHOCK
	learnset 24, SUCKER_PUNCH
	learnset 28, SWAGGER
	learnset 32, POISON_JAB
	learnset 36, TOXIC
	learnset 42, NASTY_PLOT
	learnset 48, SLUDGE_BOMB
	evos_attacks Rotom
	learnset 1, ASTONISH
	learnset 1, DOUBLE_TEAM
	learnset 5, THUNDERSHOCK
	learnset 10, CONFUSE_RAY
	learnset 25, THUNDER_WAVE
	learnset 34, DISCHARGE
	learnset 35, HEX
	learnset 40, SUBSTITUTE
	learnset 45, TRICK
	evos_attacks Lillipup
	evo_data EVOLVE_LEVEL, 16, HERDIER
	learnset 1, LEER
	learnset 1, TACKLE
	learnset 8, BITE
	learnset 20, PLAY_ROUGH
	learnset 24, CRUNCH
	learnset 28, TAKE_DOWN
	learnset 36, REVERSAL
	learnset 40, ROAR
	learnset 48, GIGA_IMPACT
	evos_attacks Herdier
	evo_data EVOLVE_LEVEL, 32, STOUTLAND
	learnset 1, BITE
	learnset 1, LEER
	learnset 1, TACKLE
	learnset 24, PLAY_ROUGH
	learnset 30, CRUNCH
	learnset 36, TAKE_DOWN
	learnset 48, REVERSAL
	learnset 54, ROAR
	learnset 66, GIGA_IMPACT
	evos_attacks Stoutland
	learnset 1, BITE
	learnset 1, LEER
	learnset 1, TACKLE
	learnset 24, PLAY_ROUGH
	learnset 30, CRUNCH
	learnset 38, TAKE_DOWN
	learnset 54, REVERSAL
	learnset 62, ROAR
	learnset 78, GIGA_IMPACT
	evos_attacks Purrloin
	evo_data EVOLVE_LEVEL, 20, LIEPARD
	learnset 1, FAKE_OUT
	learnset 1, GROWL
	learnset 1, SCRATCH
	learnset 12, FURY_STRIKES
	learnset 16, TORMENT
	learnset 24, HONE_CLAWS
	learnset 28, SUCKER_PUNCH
	learnset 32, NASTY_PLOT
	learnset 36, NIGHT_SLASH
	learnset 40, PLAY_ROUGH
	evos_attacks Liepard
	learnset 1, FAKE_OUT
	learnset 1, GROWL
	learnset 1, SCRATCH
	learnset 12, FURY_STRIKES
	learnset 16, TORMENT
	learnset 28, HONE_CLAWS
	learnset 34, SUCKER_PUNCH
	learnset 40, NASTY_PLOT
	learnset 46, NIGHT_SLASH
	learnset 52, PLAY_ROUGH
	evos_attacks Audino
	learnset 4, DISARM_VOICE
	learnset 16, GROWL
	learnset 20, ZEN_HEADBUTT
	learnset 32, TAKE_DOWN
	learnset 40, HYPER_VOICE
	learnset 48, DOUBLE_EDGE
	evos_attacks Trubbish
	evo_data EVOLVE_LEVEL, 36, GARBODOR
	learnset 9, AMNESIA
	learnset 15, TOXIC_SPIKES
	learnset 24, TAKE_DOWN
	learnset 27, SLUDGE_BOMB
	learnset 30, TOXIC
	learnset 37, PAIN_SPLIT
	learnset 39, GUNK_SHOT
	learnset 42, EXPLOSION
	evos_attacks Garbodor
	learnset 1, METAL_CLAW
	learnset 1, TAKE_DOWN
	learnset 9, AMNESIA
	learnset 15, TOXIC_SPIKES
	learnset 24, BODY_SLAM
	learnset 27, SLUDGE_BOMB
	learnset 30, TOXIC
	learnset 39, PAIN_SPLIT
	learnset 43, GUNK_SHOT
	learnset 48, EXPLOSION
	evos_attacks Klink
	evo_data EVOLVE_LEVEL, 38, KLANG
	learnset 1, THUNDERSHOCK
	learnset 28, SCREECH
	learnset 48, HYPER_BEAM
	evos_attacks Klang
	evo_data EVOLVE_LEVEL, 49, KLINKLANG
	learnset 1, THUNDERSHOCK
	learnset 28, SCREECH
	learnset 54, HYPER_BEAM
	evos_attacks Klinklang
	learnset 1, THUNDERSHOCK
	learnset 28, SCREECH
	learnset 56, HYPER_BEAM
	evos_attacks Elgyem
	evo_data EVOLVE_LEVEL, 42, BEHEEYEM
	learnset 1, CONFUSION
	learnset 1, GROWL
	learnset 12, TELEPORT
	learnset 18, PSYBEAM
	learnset 30, HEADBUTT
	learnset 36, ZEN_HEADBUTT
	learnset 43, RECOVER
	learnset 48, CALM_MIND
	learnset 60, PSYCHIC_M
	evos_attacks Beheeyem
	learnset 1, CONFUSION
	learnset 1, GROWL
	learnset 1, TELEPORT
	learnset 18, PSYBEAM
	learnset 30, HEADBUTT
	learnset 36, ZEN_HEADBUTT
	learnset 45, RECOVER
	learnset 52, CALM_MIND
	learnset 68, PSYCHIC_M
	evos_attacks Pawniard
	evo_data EVOLVE_LEVEL, 52, BISHARP
	learnset 1, LEER
	learnset 1, SCRATCH
	learnset 10, METAL_CLAW
	learnset 15, TORMENT
	learnset 20, SCARY_FACE
	learnset 35, SLASH
	learnset 40, NIGHT_SLASH
	learnset 55, IRON_HEAD
	learnset 60, SWORDS_DANCE
	evos_attacks Bisharp
	evo_data EVOLVE_LEVEL, 52, KINGAMBIT
	learnset 1, LEER
	learnset 1, METAL_CLAW
	learnset 1, SCRATCH
	learnset 15, TORMENT
	learnset 20, SCARY_FACE
	learnset 35, SLASH
	learnset 40, NIGHT_SLASH
	learnset 57, IRON_HEAD
	learnset 64, SWORDS_DANCE
	evos_attacks Kingambit
	learnset 1, LEER
	learnset 1, METAL_CLAW
	learnset 1, SCRATCH
	learnset 15, TORMENT
	learnset 20, SCARY_FACE
	learnset 35, SLASH
	learnset 40, NIGHT_SLASH
	learnset 57, IRON_HEAD
	learnset 64, SWORDS_DANCE
	evos_attacks Hawlucha
	learnset 1, HONE_CLAWS
	learnset 1, TACKLE
	learnset 4, WING_ATTACK
	learnset 12, AERIAL_ACE
	learnset 16, ENCORE
	learnset 32, BRICK_BREAK
	learnset 32, TAUNT
	learnset 36, ROOST
	learnset 40, SWORDS_DANCE
	evos_attacks MrMimeGalarian
	evo_data EVOLVE_LEVEL, 42, MR__RIME
	MrRimeEvosAttacks:
	learnset 1, RECOVER ; Slack Off → similar move
	learnset 1, ENCORE
	learnset 1, PROTECT
	learnset 1, LIGHT_SCREEN
	learnset 1, REFLECT
	learnset 1, SAFEGUARD
	learnset 1, DAZZLINGLEAM
	learnset 1, TACKLE ; Pound → similar move
	learnset 1, RAPID_SPIN
	learnset 1, BATON_PASS
	learnset 1, ICE_SHARD
	learnset 12, CONFUSION
	learnset 16, METRONOME ; Ally Switch → TR move
	learnset 20, ICY_WIND
	learnset 24, DOUBLE_KICK
	learnset 28, PSYBEAM
	learnset 32, HYPNOSIS
	learnset 36, MIRROR_COAT
	learnset 40, SUCKER_PUNCH
	learnset 44, ICE_BEAM ; Freeze-Dry → TR move
	learnset 48, PSYCHIC_M
	learnset 52, CONFUSE_RAY ; Teeter Dance → egg move

	evos_attacks Wyrdeer
	learnset 1, EXTRASENSORY ; evolution move
	learnset 1, TACKLE
	learnset 3, LEER
	learnset 7, ASTONISH
	learnset 10, HYPNOSIS
	learnset 13, STOMP
	learnset 16, MUD_SLAP ; Sand-Attack → similar move
	learnset 21, HEADBUTT ; Take Down → tutor move
	learnset 23, CONFUSE_RAY
	learnset 27, CALM_MIND
	learnset 33, TAKE_DOWN ; Role Play → Take Down
	learnset 38, ZEN_HEADBUTT
	learnset 43, THRASH ; Jump Kick → egg move
	learnset 49, SKILL_SWAP ; Imprison → tutor move
	learnset 55, HI_JUMP_KICK ; Captivate → new move
	learnset 60, MEGAHORN ; Me First → egg move
	learnset 65, DOUBLE_EDGE ; new move

	evos_attacks Kleavor
	learnset 1, ROCK_THROW ; evolution move
	learnset 1, QUICK_ATTACK
	learnset 1, LEER
	learnset 5, BULK_UP
	learnset 9, PURSUIT
	learnset 13, FALSE_SWIPE
	learnset 17, AGILITY
	learnset 21, AERIAL_ACE
	learnset 25, BUG_BITE ; Fury Cutter → similar move
	learnset 29, SLASH
	learnset 33, GLARE ; Razor Wind → new move
	learnset 37, DEFENSE_CURL ; Stealth Rock → new move
	learnset 41, X_SCISSOR
	learnset 45, CRUNCH ; Night Slash → Prism tutor move
	learnset 49, CLOSE_COMBAT ; Double Hit → SV TM move
	learnset 50, STONE_EDGE ; Stone Axe → new move
	learnset 57, SWORDS_DANCE

	evos_attacks UrsalunaPlain
	learnset 1, BULLDOZE ; evolution move
	learnset 1, GUNK_SHOT ; HGSS tutor move
	learnset 1, THIEF ; Covet → TM move
	learnset 1, SCRATCH
	learnset 1, LEER
	learnset 1, LICK
	learnset 1, BULK_UP ; Fake Tears → egg move
	learnset 8, FURY_STRIKES ; Fury Swipes → similar move
	learnset 15, FEINT_ATTACK
	learnset 22, BELLY_DRUM ; Sweet Scent → egg move
	learnset 25, PLAY_ROUGH ; Play Nice → egg move
	learnset 29, SLASH
	learnset 38, SCARY_FACE
	learnset 47, REST
	learnset 49, EARTHQUAKE ; High Horsepower → TM move
	learnset 58, THRASH
	learnset 67, CLOSE_COMBAT ; Hammer Arm → SV TM move
	learnset 76, DOUBLE_EDGE ; new move
	learnset 85, GUNK_SHOT ; SV TM move

	evos_attacks UrsalunaBloodmoon
	learnset 1, BULLDOZE ; evolution move
	learnset 1, GUNK_SHOT ; HGSS tutor move
	learnset 1, THIEF ; Covet → TM move
	learnset 1, SCRATCH
	learnset 1, LEER
	learnset 1, LICK
	learnset 1, HEALINGLIGHT ; Moonlight → similar move
	learnset 8, FURY_STRIKES ; Fury Swipes → similar move
	learnset 15, FEINT_ATTACK
	learnset 22, DEFENSE_CURL ; Harden → similar move
	learnset 25, SHADOW_BALL ; new move
	learnset 29, SLASH
	learnset 38, SCARY_FACE
	learnset 47, REST
	learnset 49, EARTH_POWER
	learnset 58, MOONBLAST
	learnset 67, FOCUS_BLAST ; Hammer Arm → SV TM move
	learnset 76, HYPER_BEAM ; Blood Moon → SV TM move
	learnset 85, GUNK_SHOT ; SV TM move

	evos_attacks Sneasler
	learnset 1, LEER
	learnset 1, BRICK_BREAK
	learnset 1, SCRATCH
	learnset 6, TAUNT
	learnset 12, QUICK_ATTACK
	learnset 18, BRICK_BREAK
	learnset 18, METAL_CLAW
	learnset 24, POISON_JAB
	learnset 36, HONE_CLAWS
	learnset 42, SLASH
	learnset 48, AGILITY
	learnset 54, SCREECH
	learnset 60, CLOSE_COMBAT
	evos_attacks Overqwil
	learnset 1, AQUA_JET ; Water Gun → SV TM move
	learnset 1, SPIKES
	learnset 1, TACKLE
	learnset 1, POISON_STING
	learnset 5, DEFENSE_CURL ; Harden → TM move
	learnset 9, MINIMIZE
	learnset 13, PIN_MISSILE
	learnset 17, ROLLOUT
	learnset 21, TOXIC_SPIKES
	learnset 25, PAIN_SPLIT ; Stockpile + Spit Up → HGSS move tutor
	learnset 29, REVERSAL ; Revenge → Sw/Sh move
	learnset 33, WATER_PULSE ; Brine → TM move
	learnset 37, CRUNCH ; Dark Pulse → SV TM move
	learnset 41, TAKE_DOWN
	learnset 45, AQUA_TAIL
	learnset 49, POISON_JAB
	learnset 53, DESTINY_BOND
	learnset 57, EXPLOSION ; Self-Destruct → similar move
	learnset 60, DOUBLE_EDGE ; Fell Stinger → event move

	evos_attacks Dudunsparce
	learnset 1, RAGE
	learnset 1, DEFENSE_CURL
	learnset 3, ROLLOUT
	learnset 6, ASTONISH ; Spite → egg move
	learnset 8, PURSUIT
	learnset 11, SCREECH
	learnset 13, MUD_SLAP
	learnset 16, YAWN ; Yawn
	learnset 18, ANCIENTPOWER
	learnset 21, BODY_SLAM
	learnset 23, DRAGON_RAGE ; Drill Run → new move
	learnset 26, ROOST
	learnset 28, TAKE_DOWN
	learnset 31, DRAGON_DANCE ; Coil → new move
	learnset 33, DIG
	learnset 36, GLARE
	learnset 38, DOUBLE_EDGE
	learnset 41, EARTHQUAKE ; Endeavor → TM move
	learnset 43, AIR_SLASH
	learnset 46, HEX ; Dragon Rush → egg move
	learnset 48, ENDURE
	learnset 51, REVERSAL ; Flail → similar move
	learnset 53, HURRICANE
	learnset 56, HYPER_VOICE ; Boomburst → similar move
	learnset 58, OUTRAGE ; new move

	evos_attacks Clodsire
	learnset 1, MEGAHORN ; evolution move
	learnset 1, MUD_SLAP ; Mud Shot → similar move
	learnset 1, LEER ; Tail Whip → similar move
	learnset 5, TACKLE
	learnset 9, POISON_STING ; Poison Tail → similar move
	learnset 15, HEADBUTT ; Slam → tutor move
	learnset 19, RECOVER ; Mud Bomb → egg move
	learnset 24, AMNESIA
	learnset 31, YAWN ; Yawn
	learnset 36, EARTHQUAKE
	learnset 41, POISON_JAB
	learnset 48, TOXIC_SPIKES
	learnset 53, GUNK_SHOT ; Sludge Wave → similar move

	evos_attacks Annihilape
	learnset 1, SHADOW_CLAW ; Shadow Punch → similar move ; evolution move
	learnset 1, OUTRAGE
	learnset 1, RAGE
	learnset 1, SCRATCH
	learnset 1, LOW_KICK
	learnset 1, LEER
	learnset 1, BULK_UP
	learnset 5, FURY_STRIKES ; Fury Swipes → similar move
	learnset 8, KARATE_CHOP
	learnset 12, PURSUIT
	learnset 15, SEISMIC_TOSS
	learnset 19, SWAGGER
	learnset 22, CROSS_CHOP
	learnset 26, REVERSAL ; Assurance → egg move
	learnset 30, FEINT_ATTACK ; Punishment → new move
	learnset 35, THRASH
	learnset 39, CLOSE_COMBAT
	learnset 44, SCREECH
	learnset 48, GUNK_SHOT ; Stomping Tantrum → HGSS tutor move
	learnset 53, OUTRAGE

	; Also terminates previous mon's learnset
	EggEvosAttacks:
	db -1 ; no more evolutions
	db -1 ; no more level-up moves
