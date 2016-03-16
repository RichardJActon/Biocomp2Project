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


my $locusMarker = qr/^LOCUS\s{7}/;

####################################################################################################
#####################################  Extract DNA sequences   #####################################
####################################################################################################
my $DNA_seq_StartMarker = qr/^ORIGIN/;
my $DNA_seq_EndMarker = qr/\/\//;
my $DNA_seq_substittions = qr/[0-9]|\n|\s/;

my @DNA_seqs;
@DNA_seqs = DBsubroutines::EXTRACT_LOCUS_FEATURE(\@lines,\@loci,$locusMarker,$DNA_seq_StartMarker,$DNA_seq_EndMarker); #,$DNA_seq_substittions

for (my $i = 0; $i < scalar @DNA_seqs; $i++) 
{
	print "$DNA_seqs[$i]\n";
}

my @DNA_seq_substituted;
@DNA_seq_substituted = DBsubroutines::SUBSTITUTIONS(\@DNA_seqs,$DNA_seq_StartMarker,$DNA_seq_EndMarker,$DNA_seq_substittions);

for (my $i = 0; $i < scalar @DNA_seq_substituted; $i++) 
{
	print "$DNA_seq_substituted[$i]\n";
}

####################################################################################################
#####################################  Extract Protein sequences   #################################
####################################################################################################
my $protein_seq_StartMarker = qr/\/translation="/;
my $protein_seq_EndMarker = qr/\"\n/;
my $protein_seq_substittions = qr/[0-9]|\n|\s/;

#######################

my @protein_seqs;
@protein_seqs = DBsubroutines::EXTRACT_LOCUS_FEATURE(\@lines,\@loci,$locusMarker,$protein_seq_StartMarker,$protein_seq_EndMarker); #,$protein_seq_substittions

for (my $i = 0; $i < scalar @protein_seqs; $i++) 
{
	print "$protein_seqs[$i]\n";
}

my @protein_seq_substituted;
@protein_seq_substituted = DBsubroutines::SUBSTITUTIONS(\@protein_seqs,$protein_seq_StartMarker,$protein_seq_EndMarker,$protein_seq_substittions);

for (my $i = 0; $i < scalar @protein_seq_substituted; $i++) 
{
	print "$protein_seq_substituted[$i]\n";
}
