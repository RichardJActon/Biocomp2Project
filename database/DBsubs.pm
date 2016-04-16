package DBsubs;
use strict;
use warnings;

=pod

=head2 BDsubs Module

=cut

####################################################################################################
##### 								  		File Checks 									   #####
####################################################################################################
=pod

=head2 File Checks

=over



=back

=cut
########
=pod

=head3 EXISTS function

=head4 Arguments

=over

=item *
File 

=back

=head4 Returns

=over

=item *
Returns 1 if the file exists

=item *
Returns 0 if the file does not exist

=back

=cut



sub EXISTS
{
	my $file = $_[0];
	if (-e $file) 
	{
		return 1;
	}
	else
	{
		return 0;
	}
}
####################################################################################################
=pod

=head3 IS_TEXT function

=head4 Arguments

=over

=item *
File 

=back

=head4 Returns

=over

=item *
Returns 1 if the file is text

=item *
Returns 0 if the file is not text

=back

=cut



sub IS_TEXT
{
	my $file = $_[0];
	if (-T $file) 
	{
		return 1;
	}
	else
	{
		return 0;
	}
}
####################################################################################################
=pod

=head3 IS_READABLE function

=head4 Arguments

=over

=item *
File 

=back

=head4 Returns

=over

=item *
Returns 1 if file is readable

=item *
Returns 0 if file is not readable

=back

=cut
sub IS_READABLE
{
	my $file = $_[0];
	if (-r $file) 
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

####################################################################################################
##### 								  FILE_LINES_TO_ARRAY									   #####
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
Reads in every line from a file pushing each line to an array as it does so, returns this array.

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
#####  									HASH_LOCI_CONTENTS									   #####
####################################################################################################
=pod

=head3 HASH_LOCI_CONTENTS

=head4 Arguments

=over

=item *
Array ref of lines from the input file

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

Takes an array ref of input data, and regexes of start and end markers and output a hash with keys derived
 from a capture in the start marker and values derived from the contatonated contents of the array until a stop
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
			$loci{$k} = $lines[$i]; # set the first line of the string in the hash to the line containing the locus start marker
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
#####  											EXTRACT_LOCUS_FEATURE			 		       #####
####################################################################################################
=pod

=head3 EXTRACT_LOCUS_FEATURE

=head4 Arguments

=over

=item *
Hash ref with values containing a concatonated string of all the values corresponding to a given key
 from the input file. 

=item *
A regex containing a capture for the feature of interest from the string.

=back

=head4 Returns

=over

=item *
A hash with the same keys as the input hash and values corresponding to the the capture of the
 regex argument.

=back

=head4 Synopsis
Extracts features of interest defined by a regex containg a capture given as an argument from 
the values of a hash given as an argument, returning a hash with the same key as input hash ref
and values corresponding to the capture in the regex.

=cut
sub EXTRACT_LOCUS_FEATURE
{
	## input variables:	
	my %loci = %{$_[0]};		# 
	my $featureRegex = $_[1];	# Regex capturing the feature of interest
	## local variables:
	my %feature;
	#my %errors;
	############################################################
	while (my($k,$v) = each %loci) 
	{
		my $string = "";
		if ($v =~ /${featureRegex}/s)
		{
			$string = $1;
			if ("" ne $string) {
				$feature{$k} = $string;
			}
			else
			{
				$feature{$k} = "Parsing error feature not defined";
			}
		}
	}
	############################################################
	return %feature;
}
####################################################################################################
#####  											SUBSTITUTIONS 							       #####
####################################################################################################
=pod

=head3 SUBSTITUTIONS

=head4 Arguments

=over

=item *
Hash ref with values containing strings to be the subject of the substitution opperation(s).

=item *
Regex for the desired substitution operation(s).

=back

=head4 Returns

=over

=item *
Hash with the same keys as the input hash ref and, values corresponding to the original values
of the hash ref after they have been subject to the substitution opperation(s) described in the 
reges provided as an argument.

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
		if ("" ne $tempFeature) {
				$outHash{$k} = $tempFeature;
			}
			else
			{
				$outHash{$k} = "Parsing error feature not defined";
			}

		#$outHash{$k} = $tempFeature;
		#print "$tempFeature\n";
	}
	############################################################
	return %outHash;
}

####################################################################################################
####################################################################################################
1;