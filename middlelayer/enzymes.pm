package middle::enzymes;

use strict;
use warnings;




##################################################################################
# Subroutine: get_regions                                                        #
# Purpose: divide the DNA sequence into: 5 region, middle region and 3 region.   #
# Input paramater: 1 string and 1 hash; the full DNA sequence and the exons hash. #                           
# Returns: 3 strings; the 5 region, the middle region and the 3 region.          #
##################################################################################


sub get_regions

{
   my ($seq, %exons) = @_;


# In the lines below I retrieve from the exons hash
# the start position of the first exon,
# to know where the 5 region terminates;

    my $start = "";

   foreach my $key (sort {$a <=> $b} keys %exons)   {
      $start = $key;
       last;
  }

# In the lines below I retrive from the exon hash the
# end position of the last exon; to do this I retrieve
# the start position of the last exon and I add
# the length to it, which is the value in my exons hash;
# I do this to know where the 3 region starts.

   my $end = "";

   foreach my $key (sort {$b <=> $a} keys %hash)   {
      $end = ($key + $hash{$key});
      last;
   }
    

   my $len = length($seq);


# Below I use the substr. function to capture the 5 region, the middle
# region and 3 region;
# In the substr. functions below I had to substract 1 in a few occasions
# because when using substr. the first position is position 0
# while in the exons data the start positions are calculated 
# starting from 1; therefore if an exon starts at position ie. 3
# using substring that would be position 2.

   my $five_end = substr($seq, 0, ($start - 1));
   my $middle_section = substr($seq, ($start - 1), ($end - $start));
   my $three_end = substr($seq,($end - 1), ($len - $end));

   return $five_end, $middle_section, $three_end;

}



##################################################################################
# Subroutine: check_ecori                                                        #
# Purpose: check wether EcoRi can cut the sequence at the 5 and/or 3 region but  #
# not inbetween.                                                                 #
# Input paramater: 3 strings; the 5, the middle and the 3 region.                #                           
# Returns: true if Ecori is able to cut the sequence at the 5 or 3 end and not   #
# inbetween; false if it is unable to cut the sequence in this specific way.     #
# Note: the front end task is to highlight those enzymes able to cut the sequence#
# this way, not to highlight the sites in the sequence.                          #
##################################################################################




sub check_ecori

{
    my ($five, $middle, $three) = @_;

# The site for EcoRi is palindromic so the complementary sequence
# would be the same. 

    if ($five =~ /gaattc/gi or $three =~ /gaattc/gi)   {
        if ($middle !~ /gaattc/gi)   {
            return 1;
        }
        else {
           return 0;
       }
   }

  
}

##################################################################################
# Subroutine: check_bamhi                                                        #
# Purpose: check wether BamHI can cut the sequence at the 5 and/or 3 region but  #
# not inbetween.                                                                 #
# Input paramater: 3 strings; the 5, the middle and the 3 region.                #                           
# Returns: true if BamHI is able to cut the sequence at the 5 or 3 end and not   #
# inbetween; false if it is unalbe to cut the sequence in this specific way.      #
##################################################################################

sub check_bamhi

{
    my ($five, $middle, $three) = @_;

# The site for BamHI is palindromic so the complementary sequence
# would be the same. 

    if ($five =~ /ggatcc/gi or $three =~ /ggatcc/gi)   {
        if ($middle !~ /ggatcc/gi)   {
            return 1;
        }
        else {
           return 0;
       }
   }

  
}


##################################################################################
# Subroutine: check_bsumi                                                       #
# Purpose: check wether BsuMI can cut the sequence at the 5 and/or 3 region but  #
# not inbetween.                                                                 #
# Input paramater: 3 strings; the 5, the middle and the 3 region.                #                           
# Returns: true if BsuMI is able to cut the sequence at the 5 or 3 end and not   #
# inbetween; false if it is unable to cut the sequence in this specific way.      #
##################################################################################

sub check_bsumi

{
    my ($five, $middle, $three) = @_;

# The site for BsuMI is palindromic so the complementary sequence
# would be the same. 

    if ($five =~ /ctcgag/gi or $three =~ /ctcgag/gi)   {
        if ($middle !~ /ctcgag/gi)   {
            return 1;
        }
        else {
           return 0;
       }
   }

  
}


1;

