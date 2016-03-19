#!/usr/bin/perl
use strict;
use warnings;
use DBsubs;
####
####################################################################################################
## 
####################################################################################################
=pod

=head2 Main Parser Script

=cut

=pod

=cut
####################################################################################################
## loci
####################################################################################################
my $infile = $ARGV[0];
my @lines = DBsubs::FILE_LINES_TO_ARRAY($infile);

# prints every line in file
# for (my $i = 0; $i < scalar @lines; $i++) 
# {
# 	print "$lines[$i]\n";
# }

my $locusStartIdentifier = qr/^LOCUS\s{7}(\w+)\b/;
my $locusEndIdentifier = qr/\/\/\n/;
#my $locusRegex = qr/^LOCUS\s{7}(\w+)\b(.*)\/\/\n/s;
my %loci = DBsubs::HASH_LOCI_CONTENTS(\@lines,$locusStartIdentifier,$locusEndIdentifier);

# prints every locus entry in the file preceeded by its accession
# while (my($k,$v) = each %loci) 
# {
# 	print "[$k]\n $v\n\n";
# }

####################################################################################################
## features
####################################################################################################


####################################################################################################
## DNA sequence
####################################################################################################
my $DNA_seq_Regex = qr/ORIGIN(.*)\/\/\n/s;
my $DNA_seq_substittions = qr/[0-9]|\n|\s/;
#
#extract
my %DNA_seq_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$DNA_seq_Regex);
#substitute
my %DNA_seq = DBsubs::SUBSTITUTIONS(\%DNA_seq_raw,$DNA_seq_substittions);

# while (my($k,$v) = each %DNA_seq_raw) 
# {
# 	print "[$k]\n $v\n\n";
# }

while (my($k,$v) = each %DNA_seq) 
{
	print "[$k]\n $v\n\n";
}

####################################################################################################
############################################  Extract Join   #######################################
####################################################################################################
my $join_Regex = qr/.*join\(([^\)]+)/s;
my $join_substittions = qr/\n|\<|\>|\s|\w+\.\d+:/;
#
#extract
my %join_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$join_Regex);
#substitute
my %join = DBsubs::SUBSTITUTIONS(\%join_raw,$join_substittions);

while (my($k,$v) = each %join_raw) 
{
	print "[$k]\n $v\n\n";
}

print "#########################\n";

while (my($k,$v) = each %join) 
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

#
my %loci_contents;
	$loci_contents{accession} =

while (my($k,$v) = each %loci) 
{
	$loci_contents{$k} = 
}

