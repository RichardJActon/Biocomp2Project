#!/usr/bin/perl
use warnings;
use strict;
use DBsubroutines;
# my $line = <>;
# my $count = 0;

# #while ($line = <>) {
# 	while ($line !~ /^\n/ and defined $line) {
# 		print "$line";
# 		#print "hit\n";
# 		$count++;
# 		$line = <>;
# 	}
# #$line = <>;
# #}
# print "\n$count\n"

########################################################
my @loci;
my $line;
my @lines;
#my %seqs;
while ($line = <>) 
{
push @lines, $line;
	if ($line =~ /^LOCUS\s{7}(\w{8})/) 
	{
		push @loci, $1;
		print "$1\n";
	}	
}

####################################################

my $locusMarker = qr/^LOCUS\s{7}/;
my $featuerStartMarker = qr/^ORIGIN/;
my $featuerEndMarker = qr/^\/\//;
my $substittions = qr/[0-9]|\n|\s/;

#######################

my @array;
@array = DBsubroutines::EXTRACT_LOCUS_FEATURE(\@lines,\@loci,$locusMarker,$featuerStartMarker,$featuerEndMarker,$substittions);

for (my $i = 0; $i < scalar @array; $i++) {
	print "$array[$i]\n";
}
###########

