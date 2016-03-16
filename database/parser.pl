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
###############
## extracts all loci accesssions from the file
while ($line = <>) 
{
push @lines, $line;
	if ($line =~ /^LOCUS\s{7}(\w{8})/) 
	{
		push @loci, $1;
	}	
}

## prints all loci accessions extracted from the file
for (my $i = 0; $i < scalar @loci; $i++) 
{
	print "$loci[$i]\n";
}
print "\n";
########################################################
## prints every line in file
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
###############
my @DNA_seqs;
@DNA_seqs = DBsubroutines::EXTRACT_LOCUS_FEATURE(\@lines,\@loci,$locusMarker,$DNA_seq_StartMarker,$DNA_seq_EndMarker); #,$DNA_seq_substittions
###############
for (my $i = 0; $i < scalar @DNA_seqs; $i++) 
{
	print "$DNA_seqs[$i]\n";
}
###############
my @DNA_seq_substituted;
@DNA_seq_substituted = DBsubroutines::SUBSTITUTIONS(\@DNA_seqs,$DNA_seq_StartMarker,$DNA_seq_EndMarker,$DNA_seq_substittions);
###############
my $genCount = 0;
for (my $i = 0; $i < scalar @DNA_seq_substituted; $i++) 
{
	print "$DNA_seq_substituted[$i]\n";
	$genCount++;
}
print "$genCount\n";
####################################################################################################
#####################################  Extract Protein sequences   #################################
####################################################################################################
my $protein_seq_StartMarker = qr/\/translation="/;
my $protein_seq_EndMarker = qr/\"\n/;
my $protein_seq_substittions = qr/[0-9]|\n|\s/;
###############
my @protein_seqs;
@protein_seqs = DBsubroutines::EXTRACT_LOCUS_FEATURE(\@lines,\@loci,$locusMarker,$protein_seq_StartMarker,$protein_seq_EndMarker); #,$protein_seq_substittions
###############
for (my $i = 0; $i < scalar @protein_seqs; $i++) 
{
	print "$protein_seqs[$i]\n";
}
###############
my @protein_seq_substituted;
@protein_seq_substituted = DBsubroutines::SUBSTITUTIONS(\@protein_seqs,$protein_seq_StartMarker,$protein_seq_EndMarker,$protein_seq_substittions);
###############
my $protCount = 0;
for (my $i = 0; $i < scalar @protein_seq_substituted; $i++) 
{
	print "$protein_seq_substituted[$i]\n";
	$protCount++;
}
print "$protCount\n";
####################################################################################################
##################################  Extract Chromosome Locations   #################################
####################################################################################################
my $chromloc_seq_StartMarker = qr/\/map="/;
my $chromloc_seq_EndMarker = qr/\"\n/;
my $chromloc_seq_substittions = qr/\n|\s/;
###############
my @chromloc_seqs;
@chromloc_seqs = DBsubroutines::EXTRACT_LOCUS_FEATURE(\@lines,\@loci,$locusMarker,$chromloc_seq_StartMarker,$chromloc_seq_EndMarker); #,$chromloc_seq_substittions
###############
for (my $i = 0; $i < scalar @chromloc_seqs; $i++) 
{
	print "$chromloc_seqs[$i]\n";
}
###############
my @chromloc_seq_substituted;
@chromloc_seq_substituted = DBsubroutines::SUBSTITUTIONS(\@chromloc_seqs,$chromloc_seq_StartMarker,$chromloc_seq_EndMarker,$chromloc_seq_substittions);
###############
my $mapCount = 0;
for (my $i = 0; $i < scalar @chromloc_seq_substituted; $i++) 
{
	print "$chromloc_seq_substituted[$i]\n";
	$mapCount++;
}
print "$mapCount\n";
####################################################################################################
#################################  Extract Protein product Names   #################################
####################################################################################################
my $product_seq_StartMarker = qr/\/product="/;
my $product_seq_EndMarker = qr/\"\n/;
my $product_seq_substittions = qr/\n/;
###############
my @product_seqs;
@product_seqs = DBsubroutines::EXTRACT_LOCUS_FEATURE(\@lines,\@loci,$locusMarker,$product_seq_StartMarker,$product_seq_EndMarker); #,$product_seq_substittions
###############
for (my $i = 0; $i < scalar @product_seqs; $i++) 
{
	print "$product_seqs[$i]\n";
}
###############
my @product_seq_substituted;
@product_seq_substituted = DBsubroutines::SUBSTITUTIONS(\@product_seqs,$product_seq_StartMarker,$product_seq_EndMarker,$product_seq_substittions);
###############
my $productCount = 0;
for (my $i = 0; $i < scalar @product_seq_substituted; $i++) 
{
	print "$product_seq_substituted[$i]\n";
	$productCount++;
}
print "$productCount\n";





####################################################################################################
############################################  Extract Join   #######################################
####################################################################################################
my $join_seq_StartMarker = qr/.*join\(/;
my $join_seq_EndMarker = qr/\)\n/;
my $join_seq_substittions = qr/\n|\<|\>|\s/;
###############
my @join_seqs;
@join_seqs = DBsubroutines::EXTRACT_LOCUS_FEATURE(\@lines,\@loci,$locusMarker,$join_seq_StartMarker,$join_seq_EndMarker); #,$join_seq_substittions
###############
for (my $i = 0; $i < scalar @join_seqs; $i++) 
{
	print "$join_seqs[$i]\n";
}
###############
my @join_seq_substituted;
@join_seq_substituted = DBsubroutines::SUBSTITUTIONS(\@join_seqs,$join_seq_StartMarker,$join_seq_EndMarker,$join_seq_substittions);
###############
my $joinCount = 0;
for (my $i = 0; $i < scalar @join_seq_substituted; $i++) 
{
	print "$join_seq_substituted[$i]\n";
	$joinCount++;
}
print "$joinCount\n";

#############
print "Separating the individual exon Boundaries form the join:\n";
my %exonStarts;
my %exonEnds;


for (my $i = 0; $i < scalar @join_seq_substituted; $i++) 
{
	for ( $i < scalar @loci) 
	{		
		my @exonStarts = "";
		my @exonEnds = "";
		@exonStarts = $join_seq_substituted[$i] =~ /(\d+)\.\./g;
		@exonEnds = $join_seq_substituted[$i] =~ /\.\.(\d+)/g;
		$exonStarts{$loci[$i]} = \@exonStarts;
		$exonEnds{$loci[$i]} = \@exonEnds;
	}
}
print "\n\nexon starts: \n";
while (my($k,$v) = each %exonStarts) 
{
	my @v = @{$v};
	print "$k @v\n";
}
print "\n\nexon ends: \n";
while (my($k,$v) = each %exonEnds) 
{
	my @v = @{$v};
	print "$k @v\n";
}
###########
# for (my $i = 0; $i < scalar @exonStarts; $i++) 
# {
# 	print "$exonStarts[$i]\n";
# }
# for (my $i = 0; $i < scalar @exonEnds; $i++) 
# {
# 	print "$exonEnds[$i]\n";
# }