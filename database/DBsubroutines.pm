package DBsubroutines;
use strict;
use warnings;
####################################################################################################
sub EXTRACT_LOCUS_FEATURE
{
# input variables	
	my @lines = @{$_[0]};	 		# array of all the lines form the input file
	my @loci = @{$_[1]}; 			# array of unique identifiers of the locus
	my $locusMarker = $_[2];		# regex of characteristic markup adjacent to the locus identifiers
	my $featuerStartMarker = $_[3];	# regex of characteristic markup preceding the feature of interest
	my $featuerEndMarker = $_[4];	# regex of characteristic markup following the feature of interest


# local variables
	my @outArray;
	my $attribute = "";
	my $subattribute = "";

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
					$attribute .= $lines[$j];
					$j++;
				}
				if ($lines[$j] =~ /${featuerEndMarker}/ and defined $lines[$j]) {
					$attribute .= $lines[$j];
				}
				push @outArray, $attribute;
				$attribute = "";
			}
		}
	}
	return @outArray;
}
####################################################################################################
sub SUBSTITUTIONS
{
	my @outArray;

	my @inArray = @{$_[0]};
	my $featuerStartMarker = $_[1];	# regex of characteristic markup preceding the feature of interest
	my $featuerEndMarker = $_[2];	# regex of characteristic markup following the feature of interest
	my $substittions = $_[3];		# regex of any features recurrent characters e.g. whitespace newline to removed from the string

	for (my $i = 0; $i < scalar @inArray; $i++) {
		my $tempFeature = "";
		$tempFeature = $inArray[$i];
		$tempFeature =~ s/${featuerStartMarker}//g;
		$tempFeature =~ s/${featuerEndMarker}//g;
		$tempFeature =~ s/${substittions}//g;
		push @outArray, $tempFeature;
		#print "$tempFeature\n";
	}
	return @outArray;
}

####################################################################################################
1;