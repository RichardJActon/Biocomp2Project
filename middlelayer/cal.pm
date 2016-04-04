package middle::cal;

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
   my @aminos = $_[0] =~ /[A-Z]/gi;
   

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
# Input paramater: 2 strings and 1 hash. The full DNA sequence, the codon start (reading #
# frame) and an hash where keys = exon start and values =  exon length.                  #                                          #
# Returns: a string, the coding sequence.                                                #
##########################################################################################

sub connect_exons

{
   my ($sequence, $reading, %exons) = @_;
   my $coding_seq = "";

   foreach my $key (sort {$a<=>$b} keys %exons)   {
      $coding_seq .= substr($sequence, ($key - 1), $exons{$key});
   }

# I have used ($key - 1) as start of exons because when using substring
# position 0 is the first character; this does not seem to be the case
# for exons data: if an exon starts at 1 it means it starts from the first character
# of the sequence which would be position 0 when using substring.
 

# Below I adjust the coding sequence depending on the reading frame;
# Codon count can start at position 1, 2 or 3 in the first exon, so 
# I cut the sequence accordingly.
 
   my $length = length($coding_seq);
   $coding_seq = substr($coding_seq, ($reading - 1), $length - ($reading - 1)); 
   return $coding_seq;
}


##########################################################################################
# Subroutine: extract_exons                                                              #
# Purpose: extract the exons from the sequence and place them in an array for the front  #
# end to highlight them in the sequence.                                                 #
# Input paramater: 1 string of the full DNA sequence and an hash where keys = exon start #
# and values =  exon length.                                                             #
# Returns: an array where each value is an exon.                                         #
##########################################################################################


sub extract_exons

{

  my ($sequence, %exons_pos) = @_;
  
  my @exons;

  foreach my $key (keys %exons_pos)   {
     my $exon = substr($sequence, ($key - 1), $exons_pos{$key});
     push @exons, $exon;

  }

  return @exons;

}

1;

