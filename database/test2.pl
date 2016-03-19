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





###############################################

#my $outfile = $ARGV[1];

# open(INFILE, "<$infile");
# open(OUTFILE, ">$outfile");





# print STDOUT "Closing files...\n";
# close(INFILE) or die "Unable to close file: $infile\n";
# close(OUTFILE) or die "Unable to close file: $outfile\n";
###############################################


=pod

=head3 Print extracted content for Loci table to "|" seperated file 

=cut

###############################################
###############################################
while (my($k,$v) = each %loci) {
	print "$k";
	print "|";
	print "$Locus_GI{$k}";
	print "|";
	print "$DNA_seq{$k}";
	print "|";
	print "$Product_Name{$k}";
	print "|";
	print "$CDS_translated{$k}";
	print "\n";
}

###############################################
###############################################