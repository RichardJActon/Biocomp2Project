package middle::firstquery;
##############################################################################################################
# Subroutine: get_results                                                                                    #
# Purpose: executes user search and retrieve results from the database.                                      #
# Input paramater: 2 strings; the 1st string is the type of search (product                                  #          
# name, genbank_accession, gene_id or location) captured from the dropdown                                   #
# box of the application; the second string is what the user types in the searchbox of the application.      #
# Returns: an hash where the keys are accession numbers and values are the corresponding                     #
# gene id, chromosome location and product name concatenated together.                                       #
##############################################################################################################
sub get_results

{
   chomp $_[1];

   my $sql = "SELECT Genebank_Accession, 
                     GI_number, 
                     Chromosome_Location_Id, 
                     Product 
              FROM Loci WHERE $_[0] = '$_[1]'";



   my $sth = $dbh->prepare($sql);

   my %results;

   if($sth && $sth->execute)   {
        
      while(my ($accession, $id, $location, $prod_name) = $sth->fetchrow_array)   {
         my $value = "$id     $location     $prod_name";
         $results{$accession} = $value;
     }
      return %results;
   }
}


  

