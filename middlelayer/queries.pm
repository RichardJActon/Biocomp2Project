package middle::queries;

use strict;
use warnings;

#########################################################################
# Subroutine: get_sequences                                             #
# Purpose: retrieve DNA sequence and Protein sequence of 1 entry.       #
# Input paramater: 1 string, the accession number of the entry.         #
# Returns: 2 strings; the nucleotide sequence and the protein sequence. #
#########################################################################


sub get_sequences

{
   chomp $_[0];

   my $sql = "SELECT DNA_sequence, 
                     CDS_translated 
              FROM Loci WHERE Genebank_Accession = '$_[0]'";


# We know this query will only return 1 row.

    if($dbh)  {

    my ($nucleo_seq, $aa_seq) = $dbh->selectrow_array($sql);

    return $nucleo_seq, $aa_seq;
  }
}

#########################################################################
# Subroutine: make_exons_hash                                           #
# Purpose: retrieve exons positions and lengths for 1 entry.              #
# Input paramater: 1 string, the accession number of the entry.         #
# Returns: an hash where keys are exons start positions and values the  #
# corresponding lengths.                                                #
#########################################################################



sub make_exons_hash

{
   chomp $_[0];

   my $sql = "SELECT StartPosition, 
                     EndPosition
              FROM Exons WHERE Genebank_Accession = '$_[0]'";




   my $sth = $dbh->prepare($sql);

   my %exons;

   if($sth && $sth->execute)   {
        
      while(my ($start, $end) = $sth->fetchrow_array)   {
         my $length = $end - $start;
         $exons{$start} = $length;
     }
     return %exons;
  }
}

1;
