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
#####  									loci (Genbank Accession Numbers)					   #####
####################################################################################################
=pod

=head3 

=cut

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
#####  										features										   #####
####################################################################################################
=pod

=head3 

=cut



####################################################################################################
######									Locus_GI											   #####
####################################################################################################
=pod

=head4 

=cut

my $Locus_GI_Regex = qr/VERSION.*GI\:(.*)\nKEYWORDS/s;
my $Locus_GI_substittions = qr/[A-Z]|\s|\n/;
#
#extract
my %Locus_GI_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$Locus_GI_Regex);
#substitute
my %Locus_GI = DBsubs::SUBSTITUTIONS(\%Locus_GI_raw,$Locus_GI_substittions);
#
#prints the result of the extraction
# while (my($k,$v) = each %Locus_GI_raw) 
# {
# 	print "[$k]\n $v\n\n";
# }
# print "#########################\n";
#prints the result of the substitution on the extraction
# while (my($k,$v) = each %Locus_GI) 
# {
# 	print "[$k]\n $v\n\n";
# }
####################################################################################################
#####								      DNA seq											   #####
####################################################################################################
=pod

=head4 

=cut

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
# print "#########################\n";
# while (my($k,$v) = each %DNA_seq) 
# {
# 	print "[$k]\n $v\n\n";
# }
####################################################################################################
#####								      Product Name										   #####
####################################################################################################
=pod

=head4 

=cut

my $Product_Name_Regex = qr/\/product="([^\"^\n]+)/s;
my $Product_Name_substittions = qr/\n/;
#
#extract
my %Product_Name_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$Product_Name_Regex);
#substitute
my %Product_Name = DBsubs::SUBSTITUTIONS(\%Product_Name_raw,$Product_Name_substittions);

# while (my($k,$v) = each %Product_Name_raw) 
# {
# 	print "[$k]\n $v\n\n";
# }
# print "#########################\n";
# while (my($k,$v) = each %Product_Name) 
# {
# 	print "[$k]\n $v\n\n";
# }
####################################################################################################
#####								      CDS_translated									   #####
####################################################################################################
=pod

=head4 

=cut

my $CDS_translated_Regex = qr/\/translation="([^\"]+)/s;
my $CDS_translated_substittions = qr/[0-9]|\n|\s/;
#
#extract
my %CDS_translated_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$CDS_translated_Regex);
#substitute
my %CDS_translated = DBsubs::SUBSTITUTIONS(\%CDS_translated_raw,$CDS_translated_substittions);

# #prints the result of the extraction
# while (my($k,$v) = each %CDS_translated_raw) 
# {
# 	print "[$k]\n $v\n\n";
# }
# print "#########################\n";
# #prints the result of the substitution on the extraction
# while (my($k,$v) = each %CDS_translated) 
# {
# 	print "[$k]\n $v\n\n";
# }
####################################################################################################
#####                                        Extract Join                                      #####
####################################################################################################
=pod

=head4 

=cut

my $join_Regex = qr/.*join\(([^\)]+)/s;
my $join_substittions = qr/\n|\<|\>|\s|\w+\.\d+:/;
#
#extract
my %join_raw = DBsubs::EXTRACT_LOCUS_FEATURE(\%loci,$join_Regex);
#substitute
my %join = DBsubs::SUBSTITUTIONS(\%join_raw,$join_substittions);

# while (my($k,$v) = each %join_raw) 
# {
# 	print "[$k]\n $v\n\n";
# }

# print "#########################\n";

# while (my($k,$v) = each %join) 
# {
# 	print "[$k]\n $v\n\n";
# }

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
#####                                    Extract Location_Name                                 #####
####################################################################################################
=pod

=head4 

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



###############################################

my $LociTable = $ARGV[1];
my $Chromosome_LocationsTable = $ARGV[2];
my $ExonsTable = $ARGV[3];

# open(INFILE, "<$infile");
open(LociTable, ">$LociTable");
open(Chromosome_LocationsTable, ">$Chromosome_LocationsTable");
open(ExonsTable, ">$ExonsTable");



# print STDOUT "Closing files...\n";

####################################################################################################
#####                            Export Contents of Loci table                                 #####
####################################################################################################
=pod

=head3 Print extracted content for Loci table to "|" seperated file 

=cut

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
	print LociTable "\n";
}

####################################################################################################
#####                      Export Contents of Chromosome_Locations table                       #####
####################################################################################################
=pod

=head3 Print extracted content for Loci table to "|" seperated file 

=cut

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

=head3 Print extracted content for Loci table to "|" seperated file 

=cut

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
close(LociTable) or die "Unable to close file: $LociTable\n";
close(Chromosome_LocationsTable) or die "Unable to close file: $Chromosome_LocationsTable\n";
close(ExonsTable) or die "Unable to close file: $ExonsTable\n";
