use strict;
use warnings;
use DBI;

my $dbname = "biodb";
my $dbhost = "hope";
my $dbsource = "dbi:mysql:database=$dbname;host=$dbhost";
my $username = "biodb_user";
my $password = "biodb_p";

# $type is the parametere captured from the dropdown (ie. ascension number, gene id, protein name or chrom. location).
my $type = <>;
# $input is the actual value that the user types for the search (ie. a protein name, an id, a location or an asc number).
my $input = <>;
chomp $input;
# Both values above to be captured by the CGI scritp.


my $sql = "SELECT name, exp_method FROM protein WHERE $type = '$input'";



my $dbh = DBI->connect($dbsource, $username, $password);


my $sth = $dbh->prepare($sql);

if($sth && $sth->execute)   {
        
   while(my ($exp_method, $name ) = $sth->fetchrow_array)   {
        print "$exp_method $name\n";
  }
}

