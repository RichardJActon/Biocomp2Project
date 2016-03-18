#!/usr/bin/perl
use strict;
use warnings;
use DBsubs;
####
my $infile = $ARGV[0];

my @lines = DBsubs::FILE_LINES_TO_ARRAY($infile);

# prints every line in file
# for (my $i = 0; $i < scalar @lines; $i++) 
# {
# 	print "$lines[$i]\n";
# }

my $locusStartIdentifier = qr/^LOCUS\s{7}(\w+)\b/;
my $locusEndIdentifier = qr/\/\/\n/;

my %loci = DBsubs::HASH_LOCI_CONTENTS(\@lines,$locusStartIdentifier,$locusEndIdentifier);


while (my($k,$v) = each %loci) 
{
	print "[$k]\n $v\n\n";
}





###############################################
#my $outfile = $ARGV[1];

# open(INFILE, "<$infile");
# open(OUTFILE, ">$outfile");





# print STDOUT "Closing files...\n";
# close(INFILE) or die "Unable to close file: $infile\n";
# close(OUTFILE) or die "Unable to close file: $outfile\n";