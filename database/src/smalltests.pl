#!/usr/bin/perl
use warnings;
use strict;
#use DBsubroutines;
use DBsubs;
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
# my @loci;
# my $line;
# my @lines;
# #my %seqs;
# while ($line = <>) 
# {
# push @lines, $line;
# 	if ($line =~ /^LOCUS\s{7}(\w{8})/) 
# 	{
# 		push @loci, $1;
# 		print "$1\n";
# 	}	
# }

my $infile = $ARGV[0];
my @lines = DBsubs::FILE_LINES_TO_ARRAY($infile);

my $locusStartIdentifier = qr/^LOCUS\s{7}(\w+)\b/;
my $locusEndIdentifier = qr/\/\/\n/;
#my $locusRegex = qr/^LOCUS\s{7}(\w+)\b(.*)\/\/\n/s;
my %loci = DBsubs::HASH_LOCI_CONTENTS(\@lines,$locusStartIdentifier,$locusEndIdentifier);

####################################################

# my $locusMarker = qr/^LOCUS\s{7}/;
# my $featuerStartMarker = qr/^ORIGIN/;
# my $featuerEndMarker = qr/^\/\//;
# my $substittions = qr/[0-9]|\n|\s/;

# #######################

# my @array;
# @array = DBsubroutines::EXTRACT_LOCUS_FEATURE(\@lines,\@loci,$locusMarker,$featuerStartMarker,$featuerEndMarker,$substittions);

# for (my $i = 0; $i < scalar @array; $i++) {
# 	print "$array[$i]\n";
# }
# ###########

####################################################################################################
#####								      Reading_frame	    								   #####
####################################################################################################
=pod

=head4 

=cut

my $Reading_frame_Regex = qr/\/codon_start=([^\n^\/]+)/s;
#my $Reading_frame_Regex = qr/\/map="([^\"]+)/s;
my $Reading_frame_substittions = qr/\n|\s/;
#
#extract
my %Reading_frame_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$Reading_frame_Regex);
#substitute
my %Reading_frame = DBsubs::SUBSTITUTIONS(\%Reading_frame_raw,$Reading_frame_substittions);

#prints the result of the extraction
while (my($k,$v) = each %Reading_frame_raw) 
{
	print "[$k]\n $v\n\n";
}
print "#########################\n";
#prints the result of the substitution on the extraction
while (my($k,$v) = each %Reading_frame) 
{
	print "[$k]\n $v\n\n";
}
