package middle::queries;

use strict;
use warnings;

use DBI;

my $dbname = "ar001";
my $dbhost = "hope";
my $dbsource = "dbi:mysql:database=$dbname;host=$dbhost";
my $username = "ar001";
my $password = "9v15f7%xs";



my $dbh = DBI->connect($dbsource, $username, $password);


##########################################################################################################
# Subroutine: get_results                                                                                #
# Purpose: executes user search and retrieve results from the database.                                  #
# Input paramater: 2 strings; the 1st string is the type of search (product                              #
# name, genbank_accession, gene_id or location) captured from the dropdown                               #
# box of the application; the second string is what the user types in the searchbox of the application.  #
# Returns: an hash where the keys are accession numbers and values are the corresponding                 #
# gene id, chromosome location and product name concatenated together.                                   #
##########################################################################################################

sub get_results

{
   chomp $_[0];
   chomp $_[1];

   my $sql = "SELECT a.Genbank_Accession, 
                     Locus_GI, 
                     Location_Name, 
                     Product_Name
              FROM Loci a, Chromosome_Locations c WHERE $_[0] LIKE '%$_[1]%' AND a.Genbank_Accession = c.Genbank_Accession";


   my $sth = $dbh->prepare($sql);

   my %results;

   if($sth && $sth->execute)   {
        
      while(my ($accession, $id, $location, $prod_name) = $sth->fetchrow_array)   {
         my $value = "ID: $id     PROTEIN: $prod_name     LOCATION: $location";
         $results{$accession} = $value;
     }
      return %results;
   }
}


###############################################################################
# Subroutine: get_sequences                                                   #
# Purpose: retrieve DNA sequence, Protein sequence and Codon start of 1 entry.#
# Input paramater: 1 string, the accession number of the entry.               #
# Returns: 3 strings; the nucleotide sequence, the protein sequence and the   #
# codon start (reading frame).
###############################################################################    


sub get_sequences

{
   chomp $_[0];

   my $sql = "SELECT DNA_seq, 
                     CDS_translated,
                     Reading_Frame 
              FROM Loci WHERE Genbank_Accession = '$_[0]'";


# We know this query will only return 1 row.

    if($dbh)  {

       my ($nucleo_seq, $aa_seq, $read) = $dbh->selectrow_array($sql);
       return $nucleo_seq, $aa_seq, $read;   
   } 
   
}

#########################################################################
# Subroutine: make_exons_hash                                           #
# Purpose: retrieve exons positions and lengths for 1 entry.            #
# Input paramater: 1 string, the accession number of the entry.         #
# Returns: an hash where keys are exons start positions and values the  #
# corresponding lengths.                                                #
#########################################################################



sub make_exons_hash

{
   chomp $_[0];

   my $sql = "SELECT StartPosition, 
                     EndPosition
              FROM Exons WHERE Genbank_Accession = '$_[0]'";




   my $sth = $dbh->prepare($sql);

   my %exons;

   if($sth && $sth->execute)   {
        
      while(my ($start, $end) = $sth->fetchrow_array)   {
         my $length = ($end - $start) + 1;
         $exons{$start} = $length;
     }
      return %exons;
  }
}




1;
