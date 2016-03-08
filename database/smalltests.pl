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
my $substittions = qrs/[0-9]|\n|\s//g;
#######################
#FOR MOUDLE
{
	my @outarray;
	my $attributes = "";
	my $subattribute = "";

	my @lines = @{$_[0]};
	my @loci = @{$_[1]};
	my $locusMarker = $_[2];
	my $featuerStartMarker = $_[3];
	my $featuerEndMarker = $_[4];
	my $substittions = $_[5];

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
					$subattribute =~ s/[0-9]|\n|\s//g;
					$attribute .= $subattribute;
					$subattribute = "";
				}
				push @outarray, $attribute;
				$attribute = "";
			}
		}
	}
return @outarray;
}