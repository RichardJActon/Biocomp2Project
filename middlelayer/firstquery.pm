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

# Next step subroutine will be taking the array of accession numbers and will use it to retrieve (gene id, product and location).
# Those 3 attributes for each entry will be concatenated, and the concatenated attributes for each entry will be inserted into a 
# second array.

# Following that I will have one last short subroutine which will create an hash where keys are the accession and
# values are the other 3 concatenated attributes for each accession.
# The subroutine will return an hash, which can be used in the front end to print out the query results.
# By having the accession numbers as keys it will be possible to add some tags arounde the keys to make
# each accession clickable.

# I could return the 2 arrays without creating the final hash, but I think if I return an hash it will be more front-end friendly
# and easier to print out. It could ge tricky to print 2 arrays next to each other, while with an hash we will just
# have to iterate through each key and printing out each key and value.
