package middle::firstquery;

# Subroutine: get_accession
# Purpose: executes user search and retrieve accession number/s from the database.
# Input paramater: 2 strings; the 1st string is the type of search (product 
# name, genbank_accession, gene_id or location) captured from the dropdown
# box of the application; the second string is what the user types in the searchbox of the application.
# Returns: an array containing 1 or more accession numbers (if the search type
# is location the search could return more than 1 accession number).

sub get_accession

{
   chomp $_[1];

   my $sql = "SELECT Genebank_Accession FROM Loci WHERE $_[0] = '$_[1]'";

   my $dbh = DBI->connect($dbsource, $username, $password);


   my $sth = $dbh->prepare($sql);

   my @genebank;

   if($sth && $sth->execute)   {
        
      while (my ($accession) = $sth->fetchrow_array)   {
         push @genebank, $accession;
      }
      return @genebank;
   }
}

