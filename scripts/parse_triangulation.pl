#!/usr/bin/perl

use strict;
use warnings;

my $line;

open (FILE, "< qc_egl_gl_calls_log.txt") or die $!;
#my @lines = <FILE>;
print "setcolor black\n";
while ($line  = <FILE>) { 
	chomp($line);
	if ($line =~ m/Tri::AddEdge\s*(\d+),(\d+) -> \(\d+,\d+\) -> (\d+),(\d+)/) {
		print "line $1 $2 $3 $4;\n"; 
	}
}

close(FILE);

exit 0;

