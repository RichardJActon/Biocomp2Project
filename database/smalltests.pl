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
my %seqs;
while ($line = <>) 
{
push @lines, $line;
	if ($line =~ /^LOCUS\s{7}(\w{8})/) 
	{
		push @loci, $1;
	}	
}

my @test = DBsubroutines::EXTRACT_LOCUS_FEATURE(@loci);

for (my $i = 0; $i < scalar @test; $i++) {
	print "$test[$i]\n";
}

####################################################




######################################################


my @seqs;
my $seq = "";
my $subline = "";
##############
#FOR SCIPT
my $locusMarker = qr/^LOCUS\s{7}/;
my $featuerStartMarker = qr/^ORIGIN/;
my $featuerEndMarker = qr/^\/\//;
my $substittions = qr/[0-9]|\n|\s/;
#######################
#FOR MOUDLE
{
	my @outarray;
	my $attributes = "";
	my $subattribute = "";

	my @lines = @{$_[0]}; 			# array of all the lines form the input file
	my @loci = @{$_[1]}; 			# array of unique identifiers of the locus
	my $locusMarker = $_[2];		# regex of characteristic markup adjacent to the locus identifiers
	my $featuerStartMarker = $_[3];	# regex of characteristic markup preceding the feature of interest
	my $featuerEndMarker = $_[4];	# regex of characteristic markup following the feature of interest
	my $substittions = $_[5];		# regex of any features to removed from the 

	for (my $i = 0; $i < scalar @loci; $i++) 
	{
		for (my $j = 0; $j < scalar @lines ; $j++) 
		{
			if ($lines[$j] =~ /${locusMarker}${loci[$i]}/) 
			{	
				while ($lines[$j] !~ /${featuerStartMarker}/ and defined $lines[$j]) 
				{
					$j++;	
				}
				while ($lines[$j] !~ /${featuerEndMarker}/ and defined $lines[$j])
				{				
					$j++;
					$subattribute = $lines[$j];
					if ($subattribute =~/${featuerEndMarker}/) 
					{
						$subattribute = "";
					}
					$subattribute =~ s/${substittions}//g; # possible conflict with detecting and removing start and end markers
					$attribute .= $subattribute;
					$subattribute = "";
				}
				$attribute =~ /${featuerStartMarker}//g;
				$attribute =~ /${featuerEndMarker}//g;
				push @outarray, $attribute;
				$attribute = "";
			}
		}
	}
return @outarray;
}