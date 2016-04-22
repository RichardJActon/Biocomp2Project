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

=back

=head3 Synopsis

This Script takes text files in genbank format and extracts

=over

=cut

####################################################################################################
##### 											File checks  								   ##### 
####################################################################################################
=pod

=head3 File Checks

=back



=over

=cut


my $infile = $ARGV[0];
open(INFILE, "<$infile");
##

if (DBsubs::EXISTS($infile)) 
{
	print STDOUT "$infile exists\n";
}
else
{
	print STDERR "$infile does not exist\n";
	die
}
##
if (DBsubs::IS_TEXT($infile)) 
{
	print STDOUT "$infile is a text file\n";
}
else
{
	print STDERR "$infile is not text\n";
	die
}
##
if (DBsubs::IS_READABLE($infile)) 
{
	print STDOUT "$infile is readable\n";
}
else
{
	print STDERR "$infile is not readable\n";
	die
}
##

####################################################################################################
#####  									loci (Genbank Accession Numbers)					   #####
####################################################################################################
=pod

=head3 loci (Genbank Accession Numbers)

=over

This Section Extracts genebank accession numbers from each locus in a genbank file and writes them 
to the values of a hash. All of the lines associated with that locus are writen to the values of
the hash.

=back

=head4 Subroutines used: 

=over

=item *
L<HASH_LOCI_CONTENTS|DBsubs.html#HASH_LOCI_CONTENTS>

=back

=cut

print STDOUT "Processing $infile...\n";

my @lines = DBsubs::FILE_LINES_TO_ARRAY($infile);

my $locusStartIdentifier = qr/^LOCUS\s{7}(\w+)\b/;
my $locusEndIdentifier = qr/\/\/\n/;

my %loci = DBsubs::HASH_LOCI_CONTENTS(\@lines,$locusStartIdentifier,$locusEndIdentifier);

####################################################################################################
##### 								Feature Extraction										   #####
####################################################################################################
=pod

=head3 Feature Extraction

=over

This Section contains blocks which extract individual features from the Genbank file and stores
them in a hash with Genebank Accession numbers / locus identifiers as its keys and the extracted
feature as its values.

Each Block uses two subroutines:

=over

=item *
L<HASH_LOCI_CONTENTS|\>

=item *
L<SUBSTITUTIONS|\>

=back

=back

=cut

####################################################################################################
######									Locus_GI											   #####
####################################################################################################
=pod

=head4 Locus_GI

=over

For each key in the loci hash this block extracts the Genbank identifer from the values of the loci
hash and creates a new hash with the same keys as the loci hash but with the target feature i.e. 
Genbank Identifier "Locus_GI" as their values.

=back

=cut

my $Locus_GI_Regex = qr/VERSION.*GI\:(.*)\nKEYWORDS/s;
my $Locus_GI_substittions = qr/[A-Z]|\s|\n/;
#
#extract
my %Locus_GI_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$Locus_GI_Regex);
#substitute
my %Locus_GI = DBsubs::SUBSTITUTIONS(\%Locus_GI_raw,$Locus_GI_substittions);

####################################################################################################
#####								      DNA_seq											   #####
####################################################################################################
=pod

=head4 DNA_seq

=over

For each key in the loci hash this block extracts the DNA sequence from the values of the loci
hash and creates a new hash with the same keys as the loci hash but with the target feature i.e. 
DNA sequence "DNA_seq" as their values.

=back

=cut

my $DNA_seq_Regex = qr/ORIGIN(.*)\/\/\n/s;
my $DNA_seq_substittions = qr/[0-9]|\n|\s/;
#
#extract
my %DNA_seq_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$DNA_seq_Regex);
#substitute
my %DNA_seq = DBsubs::SUBSTITUTIONS(\%DNA_seq_raw,$DNA_seq_substittions);

####################################################################################################
#####								      Product_Name										   #####
####################################################################################################
=pod

=head4 Product_Name

=over

For each key in the loci hash this block extracts the name of the protein product from the values of
the loci hash and creates a new hash with the same keys as the loci hash but with the target feature
i.e. the name of the protein product "Product_Name" as their values.

=back

=cut

my $Product_Name_Regex = qr/\/product="([^\"^\n]+)/s;
my $Product_Name_substittions = qr/\n/;
#
#extract
my %Product_Name_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$Product_Name_Regex);
#substitute
my %Product_Name = DBsubs::SUBSTITUTIONS(\%Product_Name_raw,$Product_Name_substittions);

####################################################################################################
#####								      CDS_translated									   #####
####################################################################################################
=pod

=head4 CDS_translated

=over

For each key in the loci hash this block extracts the Protein amino acid sequence from the values of
the loci hash and creates a new hash with the same keys as the loci hash but with the target feature
i.e. Protein sequence "CDS_translated" as their values.

=back

=cut

my $CDS_translated_Regex = qr/\/translation="([^\"]+)/s;
my $CDS_translated_substittions = qr/[0-9]|\n|\s/;
#
#extract
my %CDS_translated_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$CDS_translated_Regex);
#substitute
my %CDS_translated = DBsubs::SUBSTITUTIONS(\%CDS_translated_raw,$CDS_translated_substittions);

####################################################################################################
#####								      Reading_frame	    								   #####
####################################################################################################
=pod

=head4 Reading_frame

=over

For each key in the loci hash this block extracts the Reading frame of the first Exon from the 
values of the loci hash and creates a new hash with the same keys as the loci hash but with the
target feature i.e. The reading frame or offset from the DNA sequence start point of the protein 
coding sequence "Reading_frame" as their values.

=back

=cut

my $Reading_frame_Regex = qr/\/codon_start=([^\n^\/]+)/s;
my $Reading_frame_substittions = qr/\n|\s/;
#
#extract
my %Reading_frame_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$Reading_frame_Regex);
#substitute
my %Reading_frame = DBsubs::SUBSTITUTIONS(\%Reading_frame_raw,$Reading_frame_substittions);

####################################################################################################
#####                                        join 	                                           #####
####################################################################################################
=pod

=head4 join

=over

For each key in the loci hash this block extracts the Exon Start and end positions from the values
of the loci hash and creates a new hash with the same keys as the loci hash but with the target
feature i.e. the list of Exon Start and end sites "join" as their values. 

It then takes this hash with values of a string containing a list of exon start and end sites and
produces two further hashes with the same keys but whose values are array refferences to 1) an 
array of Exon start positions and 2) an array of Exon end positions.

=back

=cut

my $join_Regex = qr/.*join\(([^\)]+)/s;
my $join_substittions = qr/\n|\<|\>|\s|\w+\.\d+:/;
#
#extract
my %join_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$join_Regex);
#substitute
my %join = DBsubs::SUBSTITUTIONS(\%join_raw,$join_substittions);

#Process Join locations into array
my %exonStarts;
my %exonEnds;

while (my($k,$v) = each %join) {
	my @exonStarts = "";
	my @exonEnds = "";
	@exonStarts = $join{$k} =~ /(\d+)\.\./g;
	@exonEnds = $join{$k} =~ /\.\.(\d+)/g;
	$exonStarts{$k} = \@exonStarts;
	$exonEnds{$k} = \@exonEnds;
}

# #print STDOUT "\n\nexon starts: \n";
# while (my($k,$v) = each %exonStarts) 
# {
# 	my @v = @{$v};
# 	for (my $i = 0; $i < scalar @v; $i++) {
# 		print STDOUT "$k|$v[$i]\n";
# 	}
# }
# #print STDOUT "\n\nexon ends: \n";
# while (my($k,$v) = each %exonEnds) 
# {
# 	my @v = @{$v};
# 	for (my $i = 0; $i < scalar @v; $i++) {
# 		print STDOUT "$k|$v[$i]\n";
# 	}
# }

####################################################################################################
#####                                    	Location_Name                                      #####
####################################################################################################
=pod

=head4 Location_Name

=over

For each key in the loci hash this block extracts the chromosome location from the 
values of the loci hash and creates a new hash with the same keys as the loci hash but with the
target feature i.e. The karyotypic location in terms of chromosome number, arm and band 
"Location_name" as their values.

=back

=cut

my $Location_Name_Regex = qr/\/map="([^\"]+)/s;
my $Location_Name_substittions = qr/\n/;
#
#extract
my %Location_Name_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$Location_Name_Regex);
#substitute
my %Location_Name = DBsubs::SUBSTITUTIONS(\%Location_Name_raw,$Location_Name_substittions);

# while (my($k,$v) = each %Location_Name_raw) 
# {
# 	print "[$k]\n $v\n\n";
# }

# print "#########################\n";

# while (my($k,$v) = each %Location_Name) 
# {
# 	print "[$k]\n $v\n\n";
# }


####################################################################################################
#####										Writing Outputs									   #####
####################################################################################################
=pod

=head3 Writing outputs

=over

This section opens the output file handles, Prints the results to thos files and then closes the 
file handles including that of the input file whislt performing checks of sucessfull closing of each
file.

=back

=cut

print STDOUT "opening output files...\n";

my $LociTable = "loci.txt";
my $Chromosome_LocationsTable = "chromloc.txt";
my $ExonsTable = "exons.txt";

open(LociTable, ">$LociTable");
open(Chromosome_LocationsTable, ">$Chromosome_LocationsTable");
open(ExonsTable, ">$ExonsTable");



# print STDOUT "Closing files...\n";

####################################################################################################
#####                            Export Contents of Loci table                                 #####
####################################################################################################
=pod

=head3 Loci table output

=over

Print extracted content for Loci table to "|" seperated file 

=back

=cut

print STDOUT "Writing $LociTable...\n";

while (my($k,$v) = each %loci) {
	print LociTable "$k";
	print LociTable "|";
	print LociTable "$Locus_GI{$k}";
	print LociTable "|";
	print LociTable "$DNA_seq{$k}";
	print LociTable "|";
	print LociTable "$Product_Name{$k}";
	print LociTable "|";
	print LociTable "$CDS_translated{$k}";
	print LociTable "|";
	print LociTable "$Reading_frame{$k}";
	print LociTable "\n";
}

####################################################################################################
#####                      Export Contents of Chromosome_Locations table                       #####
####################################################################################################
=pod

=head3 Chromosome_Locations table output

=over

Print extracted content for Chromosome locations table to "|" seperated file 

=back

=cut

print STDOUT "Writing $Chromosome_LocationsTable...\n";

while (my($k,$v) = each %loci) {
	print Chromosome_LocationsTable "$k";
	print Chromosome_LocationsTable "|";
	print Chromosome_LocationsTable "$Location_Name{$k}";
	print Chromosome_LocationsTable "\n";
}

####################################################################################################
#####                                Export Contents of Exons table                            #####
####################################################################################################
=pod

=head3 Exons table output

=over

Print extracted content for Exon table to "|" seperated file 1
=back

=cut

print STDOUT "Writing $ExonsTable...\n";

my @col1;
my @col2;
my @rows;

foreach my $k (sort {$a cmp $b} keys %exonStarts)
{
	my @v = @{$exonStarts{$k}};
		for (my $i = 0; $i < scalar @v; $i++) {
		push @col1, "$k|$v[$i]";
	}
}
foreach my $k (sort {$a cmp $b} keys %exonEnds)
{
	my @v = @{$exonEnds{$k}};
		for (my $i = 0; $i < scalar @v; $i++) {
		push @col2, "|$v[$i]\n";
	}
}

for (my $i = 0; $i < scalar @col1; $i++) {
	push @rows, $col1[$i] . $col2[$i];
}

for (my $i = 0; $i < scalar @rows; $i++) { 
	print ExonsTable "$rows[$i]"
}

####################################################################################################

print STDOUT "Closing files...\n";
close(LociTable) or die "Unable to close file: $LociTable\n";
close(Chromosome_LocationsTable) or die "Unable to close file: $Chromosome_LocationsTable\n";
close(ExonsTable) or die "Unable to close file: $ExonsTable\n";
close(INFILE) or die "Unable to close file: $infile\n";