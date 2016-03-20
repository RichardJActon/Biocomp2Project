package Queries;
use strict;
use warnings;
use DBI;
###################################################################################################
#####
###################################################################################################



###################################################################################################
#####
###################################################################################################
=pod

=head3 DBI setup

=cut 
my $dbname = "Chromosome17";
my $dbserver = "localhost";
my $dbport = "3306"; # 5432?
my $datasource = "dbi:mysql:database=$dbname;host=$dbserver";
my $username = "RichardActon";
my $password = "314159";

my $dbh = DBI->connect($datasource, $username, $password);
################################################################################
# my $dbname = "ar001";
# my $dbserver = "localhost";
# my $dbport = "3306";
# my $datasource = "dbi:mysql:database=$dbname;host=$dbserver";
# my $username = "ar001";
# my $password = "9v15f7%xs";

# my $dbh = DBI->connect($datasource, $username, $password);


###################################################################################################
#####    ACCESSION_SEARCH
###################################################################################################
=pod

=head3 ACCESSION_SEARCH

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

# sub ACCESSSION_SEARCH
# {
# 	## input variables
# 	my @searchStrings = @{$_[0]};
# 	## local variables
# 	my @searchResults;
# 	my $sql = 
# 	"
# 	SELECT 
# 	"


# 	#######################################################
# 	return @searchResults;
# }
###################################################################################################
#####    LOCUS_GI_SEARCH
###################################################################################################
=pod

=head3 LOCUS_GI_SEARCH

=head4 Arguments

=over

=item *
Array of search terms

=back

=head4 Returns

=over

=item *


=back

=head4 Synopsis

=cut

sub LOCUS_GI_SEARCH
{
	## input variables
	my $searchString = $_[0];
	## local variables
	my $searchResult;
	my $sql = 
	"
	SELECT Genbank_Accession 
	FROM Loci
	WHERE Locus_GI LIKE '$searchString';
	"
	;
	$searchResult = $dbh->selectrow_array($sql);


	#######################################################
	return $searchResult;
}

###################################################################################################
#####    EXON_POSITIONS
###################################################################################################
=pod

=head3 EXON_POSITIONS

=head4 Arguments

=over

=item *
Array of search terms

=back

=head4 Returns

=over

=item *


=back

=head4 Synopsis

=cut

sub EXON_POSITIONS
{
	## input variables
	my $searchString = $_[0];
	## local variables
	my @StartPositions;
	my @EndPositions;
	my $sql = 
	"
	SELECT StartPosition, EndPosition
	FROM Exons
	WHERE Genbank_Accession = '$searchString';
	"
	;
	my $sth = $dbh->prepare($sql);
	if ($sth->execute()) 
	{
		while (my($start,$end) = $sth->fetchrow_array()) 
		{
			push @StartPositions, $start;
			print STDOUT "start $start\n";
			push @EndPositions, $end;
			print STDOUT "end $end\n";
		}
	}
	$sth->finish();
	#######################################################
	return (\@StartPositions,\@EndPositions);
}


















###################################################################################################
1;
