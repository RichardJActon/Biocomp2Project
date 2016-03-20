#!/usr/bin/perl
use strict;
use warnings;
#use DBsubroutines;
use Queries;
use DBI;
################################################################################
##### LOCUS_GI_SEARCH testing
################################################################################
my $searchString = "34424";
my $result = Queries::LOCUS_GI_SEARCH($searchString);
print "$result\n";
################################################################################
##### EXON_POSITIONS testing
################################################################################

my $searchStringx = 'Y16787';
my ($start,$end) = Queries::EXON_POSITIONS($searchStringx);
#my (@starts,@ends) = (@{$start},@{$end});
my @starts = @{$start};
my @ends = @{$end};

print "$start\n"; # $start contains an array ref
print "$end\n"; # $end contains an array ref
# end is apparently populated with uninitialised values.
print "starts @starts\n";
print "ends @ends\n"; # this does not work, problem with the dereferencing?

for (my $i = 0; $i < scalar @starts; $i++) 
{
	print "$starts[$i]\n";
	print "$ends[$i]\n";
}


################################################################################
# my $dbname = "Chromosome17";
# my $dbserver = "localhost";
# my $dbport = "3306";
# my $datasource = "dbi:mysql:database=$dbname;host=$dbserver";
# my $username = "RichardActon";
# my $password = "314159";

# my $dbh = DBI->connect($datasource, $username, $password);
################################################################################
# my $dbname = "ar001";
# my $dbserver = "localhost";
# my $dbport = "3306";
# my $datasource = "dbi:mysql:database=$dbname;host=$dbserver";
# my $username = "ar001";
# my $password = "9v15f7%xs";

# my $dbh = DBI->connect($datasource, $username, $password);
################################################################################
# for (my $i = 0; $i < scalar @loci; $i++) {
# 	my $sql = ("
# 		INSERT INTO Loci (Genebank_Accession)
# 			VALUES ('$loci[$i]');
# 		");
# 	$dbh->do($sql);
# };



################################################################################
# my @sql = (
# "
# INSERT INTO Chromosome_Locations (Chromosome_Location_ID)
# 	VALUES	(11);
# "
# ,
# "
# INSERT INTO Exons (Exon_ID,Genebank_Accession)
# 	VALUES	(10,'AB007120');

# "
# ,
# "
# INSERT INTO Loci (Genebank_Accession,Chromosome_Location_ID)
# 	VALUES	('AB007120',11);
# "
# );


# for (my $i = 0; $i < scalar @sql ; $i++) {
# 	$dbh->do($sql[$i]);
# }

## foreign key related error, maybe because they are emty?

## indexing after data load


