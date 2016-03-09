package DBsubroutines;
use strict;
use warnings;
#
sub EXTRACT_LOCUS_FEATURE(\@\@\$\$\$\$)
{
# input variables	
	my @lines = @{$_[0]}; 			# array of all the lines form the input file
	my @loci = @{$_[1]}; 			# array of unique identifiers of the locus
	my $locusMarker = $_[2];		# regex of characteristic markup adjacent to the locus identifiers
	my $featuerStartMarker = $_[3];	# regex of characteristic markup preceding the feature of interest
	my $featuerEndMarker = $_[4];	# regex of characteristic markup following the feature of interest
	my $substittions = $_[5];		# regex of any features recurrent characters e.g. whitespace newline to removed from the string

# local variables
	my @outarray;
	my $attribute = "";
	my $subattribute = "";

	for (my $i = 0; $i < scalar @loci; $i++) 
	{
		for (my $j = 0; $j < scalar @lines ; $j++) 
		{
			if ($lines[$j] =~ /${locusMarker}${loci[$i]}/) 
			{	
			#print "$lines[$j]\n";
				while ($lines[$j] !~ /${featuerStartMarker}/ and defined $lines[$j]) 
				{
					$j++;	
				}
				while ($lines[$j] !~ /${featuerEndMarker}/ and defined $lines[$j])
				{				
					$subattribute = $lines[$j];
					$subattribute =~ s/${substittions}//g; # possible conflict with detecting and removing start and end markers  - markers could be changed by this move to after marker check?
					$attribute .= $subattribute;
					$subattribute = "";
					$j++;
				}
				$attribute =~ s/${featuerStartMarker}//g;
				$attribute =~ s/${featuerEndMarker}//g;
				push @outarray, $attribute;
				$attribute = "";
			}
		}
	}
	return @outarray;
}

1;