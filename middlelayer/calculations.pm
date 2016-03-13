package middle::calculations;

use strict;
use warnings;


##############################################################################
# Subroutine: protein_spacing                                                #
# Purpose: add a "-" on eather side of each amino acid in a protein sequence.#
# Input paramater: 1 string, the protein sequence.                           #
# Returns: a string; the protein sequence in the following format:           #
# eg. -H--N--G--H-.                                                          #
##############################################################################

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


##########################################################################################
# Subroutine: connect_exons                                                              #
# Purpose: extract and connect the exons of a sequence to create the coding sequence.    #
# Input paramater: 1 string of the full DNA sequence and an hash where keys = exon start #
# and values =  exon length.                                                             #
# Returns: a string, the coding sequence.                                                #
##########################################################################################

sub connect_exons

{
   my ($sequence, %exons) = @_;
   my $coding_seq = "";

   foreach my $key (sort keys %exons)   {
      $coding_seq .= substr($sequence, ($key - 1), $hash{$key});
   }

# I have used ($key - 1) as start of exons because when using substring
# position 0 is the first character; this does not seem to be the case
# for exons data: if an exon starts at 1 it means it starts from the first character
# of the sequence which would be position 0 when using substring.
   
  return $coding_seq;
}

1;
