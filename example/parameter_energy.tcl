set nrep 288
set ngrest 8
set nreus [expr "$nrep / $ngrest"]

proc read_para {filename} {
	set lst {}
	set fileunit [open $filename "r"]
	while {[gets $fileunit line] > -1} {
		lappend lst [string trim $line]
	}
	close $fileunit
	return $lst
}

proc read_data {filename ncol} {
	set lst {}
	set fileunit [open $filename "r"]
	while {[gets $fileunit line] > -1} {
		lappend lst [lrange $line 1 end]
	}
	close $fileunit
	return $lst
}

# read spring constant from 'K.dat'
set K [read_para "input/K.dat"]

# read spring center form 'center.dat'
set center [read_para "input/center.dat"]

for {set k 1} {$k <= $nrep} {incr k} {
	set grest_energy [read_data "input/energy/$k.ene" $ngrest]
	set dist [read_data "input/dist/$k.comdis" 1]
	
	set outname "output/parameter_energy/$k.ene"

	set dirname [file dirname $outname]
	if {![file exists $dirname]} "file mkdir $dirname"
	
	set outfile [open "output/parameter_energy/$k.ene" "w"]
	set nline 0
	foreach ene_lst $grest_energy {
		set dl [lindex $dist $nline]
		incr nline
		set all_ene [format "%5d" $nline]
		for {set l 1} {$l <= $nrep} {incr l} {
			set grest_l [expr "($l - 1) / $nreus + 1"]
			set reus_l [expr "($l - 1) % $nreus + 1"]

			set K_l [lindex $K [expr "$reus_l - 1"]]
			set d0 [lindex $center [expr "$reus_l - 1"]]

			set r_e [expr "$K_l * ($dl - $d0) ** 2"]
			set g_e [lindex $ene_lst [expr "$grest_l - 1"]]

			set ene [expr "$g_e + $r_e"]
			set all_ene [format "%s%14.4f" $all_ene $ene]
		# puts "$grest_l, $reus_l"
		}
		puts $outfile $all_ene
	}
	close $outfile
    puts "generate $outname"
	
}
