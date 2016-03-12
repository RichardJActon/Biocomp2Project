package middle::calculations;

use strict;
use warnings;



# Subroutine: protein_spacing
# Purpose: add a "-" on eather side of each amino acid in a protein sequence.
# Input paramater: 1 string, the protein sequence.
# Returns: a string; the protein sequence in the following format: 
# eg. -H--N--G--H-.

sub protein_spacing

{
   my @aminos = $_[0] =~ /[A-Z\*]/gi;
   

   foreach my $value (@aminos)   {
      $value = "-" . $value . "-";
   }

   
   my $spaced_seq = "";
   
   
   foreach my $value (@aminos)   {
     $spaced_seq .= $value ;
   }
   
   
   return $spaced_seq;
}



1;
