set nrep 288
set ngrest 8
set nreus [expr "$nrep / $ngrest"]

for {set repi 1} {$repi <= $nrep} {incr repi} {
	# set input file
	set inname "input/energy/$repi.ene"
	set infile [open $inname "r"]

	# set output name
	set outname "output/target_energy/$repi.ene"
	
	# make output directory
	set dirname [file dirname $outname]
	if {![file exists $dirname]} "file mkdir $dirname"
	
	# open output file
	set outfile [open $outname "w"]

    # output target energy
	set index 0
	while {[gets $infile line] > -1} {
		incr index
		# extract the target energy for line
		set target_energy [lindex $line 1]
		set outline [format "%5d  %s" $index $target_energy]
		puts $outfile $outline
	}
	close $infile
	close $outfile
	puts "generate $outname"
}
