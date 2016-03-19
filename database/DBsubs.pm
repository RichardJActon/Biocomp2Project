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
	## input variables
	my $infile = $_[0];
	## local variables
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
####################################################################################################
##  HASH_LOCI_CONTENTS
####################################################################################################
=pod

=head3 HASH_LOCI_CONTENTS

=head4 Arguments

=over

=item *
Array of lines from the input file

=item *
Regex of locus start marker with capture for the unique identifier to become the keys of the hash

=item *
Regex to identify the end of the locus

=back

=head4 Returns

=over

=item *
Hash with keys corresponding to the unique identifier of each locus and values corresponding to the 
complete contents of the entry for that locus.

=back

=head4 Synopsis

Takes an array of input data, and regexes of start and end markers and output a hash with keys derived
 from a capture in the start marker and values derived from the contents of the array until a stop
 marker is reached.

a key assumption is that the unique identifiers that are to become the hash keys are located in the
 first line of the entry.

=cut
sub HASH_LOCI_CONTENTS
{
	## input variables:
	my @lines = @{$_[0]};
	my $locusStartMarker = $_[1];
	my $locusEndMarker = $_[2];
	## local variables:
	my %loci; 
	############################################################
	for (my $i = 0; $i < scalar @lines; $i++) 
	{
		my $k = "";
		if ($lines[$i] =~ /${locusStartMarker}/) 
		{
			$k = $1; # name the keys of the Hash after the unique locus identifier
			$loci{$k} = $lines[$i]; # set the first line of the string in the has to the line containing the locus start marker
			$i++;
		}
		while ($lines[$i] !~ /${locusEndMarker}/) # append all lines preceeding the end marker to the string
		{
			$loci{$k} .= $lines[$i];
			$i++;
		}
		if ($lines[$i] =~ /${locusEndMarker}/) # append the last line than matches the end marker to the string
		{
			$loci{$k} .= $lines[$i];
		}
	}
	############################################################
	return %loci;
}
####################################################################################################
##  EXTRACT_LOCUS_FEATURE
####################################################################################################
=pod

=head3 EXTRACT_LOCUS_FEATURE

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
sub EXTRACT_LOCUS_FEATURE
{
	## input variables:	
	my %loci = %{$_[0]};		# 
	my $featureRegex = $_[1];	# Regex capturing the feature of interest
	## local variables:
	my %feature;
	############################################################
	while (my($k,$v) = each %loci) 
	{
		my $string = "";
		if ($v =~ /${featureRegex}/s)
		{
			$string = $1;
			$feature{$k} = $string;
		}
	}
	############################################################
	return %feature;
}
####################################################################################################
##  SUBSTITUTIONS
####################################################################################################
=pod

=head3 SUBSTITUTIONS

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
sub SUBSTITUTIONS
{
	## input variables
	my %inHash = %{$_[0]};
	my $substittions = $_[1];		# regex of any features recurrent characters e.g. whitespace newline to removed from the string
	## local variables
	my %outHash;
	############################################################
	while (my($k,$v) = each %inHash)  
	{
		my $tempFeature = "";
		$tempFeature = $v;
		$tempFeature =~ s/${substittions}//g;
		$outHash{$k} = $tempFeature;
		#print "$tempFeature\n";
	}
	############################################################
	return %outHash;
}

####################################################################################################
####################################################################################################
1;