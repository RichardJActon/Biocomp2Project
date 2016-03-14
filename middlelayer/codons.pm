package middle::codons;
######################################################################
# Subroutine: calc_cod_freq                                          #
# Purpose: calculate the frequency of each codon in a given sequence.#
# Input paramater: 1 string, the coding sequence.                    #
# Returns: an hash where the keys are the codons and the values are  #
# the corresponding frequencies.                                     #
######################################################################

sub calc_cod_freq

{
   my @codons = $_[0] =~ /[A-Z]{3}/gi;

   my %codon_count;

   foreach my $codon (@codons)   {
      $codon_count{$codon}++;
   }

   my $codons_total = scalar(@codons);

   my %codonfreq;

   foreach my $cod (keys %codon_count)   {
      my $frequency = ($codon_count{$cod} * 100) / $codons_total;
         $codonfreq{$cod} = $frequency;
  }

  return %codonfreq;

}

###########################################################################################
# Subroutine: calc_cod_ratio                                                              #
# Purpose: calculate the ration of each codon encoding its amino acid in a given sequence.#
# Input paramater: 2 strings, the coding sequence and the translated amino acid sequence. #
# Returns: an hash where the keys are the codons and the values are                       #
# the corresponding usage ratio.                                                          #
###########################################################################################

sub calc_cod_ratio

{

   my @codons = $_[0] =~ /[A-Z]{3}/gi;

   my @aminos = $_[1] =~ /[A-Z\*]/gi;


   my %aa_count;

   foreach my $value (@aminos)   {
     $aa_count{$value}++;
   }

   my %cod_count;

   foreach my $value (@codons)   {
      $cod_count{$value}++;
   }


# In the 2 lines below I join my 2 original arrays in an hash called translation;        
# eack key in the hash will be a codon (so no duplicates), while each value will be      
# the amino acid which each codon translate. This way I can use this new hash to connect 
# each codon count to the correspondin amino acid count.                                 

   my %translation;


   @translation{@codons} = @aminos;

   my %codonratio;

   foreach my $codon (keys %translation)   {
      my $ratio = ($cod_count{$codon} * 100) / ($aa_count{$translation{$codon}});
         $codonratio{$codon} = $ratio;
   }


   return %codonratio;

}

###########################################################################################
# Subroutine: map_codons                                                                  #
# Purpose: connect each codon in a coding sequence with its corresponding                 #
# amino acid in the translated sequence.                                                  #
# Input paramater: 2 strings, the coding sequence and the translated amino acid sequence. #
# Returns: an hash where the keys are the codons (no duplicates) and the values are       #
# the corresponding amino acids.                                                          #
###########################################################################################
sub map_codons

{

  my @codons = $_[0] =~ /[A-Z]{3}/gi;

  my @aminos = $_[1] =~ /[A-Z\*]/gi;

  my %translation;

  @translation{@codons} = @aminos;

  return %translation;

}


1;
