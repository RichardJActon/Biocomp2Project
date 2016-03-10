#!/usr/bin/perl
use strict;
use warnings;
use DBsubroutines;
#use DBI;
#
#test script
####################################################################################################
###################################  Extract Genebank Accessions  ##################################
####################################################################################################
my @loci;
my $line;
my @lines;

while ($line = <>) 
{
push @lines, $line;
	if ($line =~ /^LOCUS\s{7}(\w{8})/) 
	{
		push @loci, $1;
	}	
}

for (my $i = 0; $i < scalar @loci; $i++) 
{
	print "$loci[$i]\n";
}
print "\n";
########################################################
##
# for (my $i = 0; $i < scalar @lines; $i++) 
# {
# 	print "$lines[$i]\n";
# }
########################################################



####################################################################################################
#####################################  Extract DNA sequences   #####################################
####################################################################################################

my $locusMarker = qr/^LOCUS\s{7}/;

my $DNA_seq_StartMarker = qr/^ORIGIN/;
my $DNA_seq_EndMarker = qr/^\/\//;
my $DNA_seq_substittions = qr/[0-9]|\n|\s/;

#######################

my @DNA_seqs;
@DNA_seqs = DBsubroutines::EXTRACT_LOCUS_FEATURE(\@lines,\@loci,$locusMarker,$DNA_seq_StartMarker,$DNA_seq_EndMarker,$DNA_seq_substittions);

for (my $i = 0; $i < scalar @DNA_seqs; $i++) {
	print "@DNA_seqs[$i]\n";
}
###########

####################################################################################################

####################################################################################################
my $Protein_seq_StartMarker = qr/\/translation="/;
my $Protein_seq_EndMarker = qr/\"/;
my $Protein_seq_substittions = qr/[0-9]|\n|\s/;

#######################

my @Protein_seqs;
@Protein_seqs = DBsubroutines::EXTRACT_LOCUS_FEATURE(\@lines,\@loci,$locusMarker,$Protein_seq_StartMarker,$Protein_seq_EndMarker,$Protein_seq_substittions);

for (my $i = 0; $i < scalar @Protein_seqs; $i++) {
	print "@Protein_seqs[$i]\n";
}