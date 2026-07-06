; Used by CheckSleepingTreeMon

AsleepTreeMons:
	table_width 1
	dr .Morn
	dr .Day
	dr .Nite
	dr .Eve
	assert_table_length NUM_DAYTIMES
.Nite
.Eve
	dp LEDYBA
	dp SPINARAK
	dp LEDIAN
	dp SPINARAK
	dp SPINARAK
	dp LEDIAN
	dp HOOTHOOT
	dp EKANS
	dp EXEGGCUTE
	dp LEDYBA
	db 0 ; end

.Morn
.Day
	dp VENONAT
	dp HOOTHOOT
	dp NOCTOWL
	dp SPINARAK
	dp HERACROSS
	db 0 ; end
