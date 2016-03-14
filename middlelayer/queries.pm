package middle::queries;

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
