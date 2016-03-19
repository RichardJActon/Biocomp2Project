#!/usr/bin/perl
use strict;
use warnings;
use DBsubroutines;
use DBI;
################################################################################




################################################################################
my $dbname = "Chromosome17";
my $dbserver = "localhost";
my $dbport = "3306";
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
################################################################################
for (my $i = 0; $i < scalar @loci; $i++) {
	my $sql = ("
		INSERT INTO Loci (Genebank_Accession)
			VALUES ('$loci[$i]');
		");
	$dbh->do($sql);
};



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


