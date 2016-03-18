package DBsubs;
use strict;
use warnings;

=pod

=head2 BDsubs Module

=cut
####################################################################################################
##  FILE_LINES_TO_ARRAY
####################################################################################################
=pod

=head3 FILE_LINES_TO_ARRAY Function

=head4 Arguments

=over

=item *
String containing name of input file

=back

=head4 Returns

=over

=item *
Array with one entry for each line of the file

=back

=head4 Synopsis

=cut
sub FILE_LINES_TO_ARRAY
{
	my $infile = $_[0];
	my $line;
	my @lines;
	############################################################
	open(INFILE, "<$infile");
	while ($line = <INFILE>) 
	{
		push @lines, $line;
	}
	close(INFILE) or die "Unable to close file: $infile\n";
	############################################################
	return @lines;
}
#####################################################################################################
##  HASH_LOCI_CONTENTS
####################################################################################################
=pod

=head3 HASH_LOCI_CONTENTS

=head4 Arguments

=over

=item *


=back

=head4 Returns

=over

=item *

=back

=head4 Synopsis


=cut
sub HASH_LOCI_CONTENTS
{
	my @lines = @{$_[0]};
	my $locusStartIdentifier = $_[1];
	my $locusEndIdentifier = $_[2];

	my %loci; 
	############################################################
	for (my $i = 0; $i < scalar @lines; $i++) 
	{
		my $k = "";
		if ($lines[$i] =~ /${locusStartIdentifier}/) 
		{
			$k = $1;
			$loci{$k} = $lines[$i];
			$i++;
		}
		while ($lines[$i] !~ /${locusEndIdentifier}/) {
			$loci{$k} .= $lines[$i];
			$i++;
		}
	}
	############################################################
	return %loci;
}
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