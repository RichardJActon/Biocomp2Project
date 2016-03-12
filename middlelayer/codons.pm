package middle::codons;

# Subroutine: calc_cod_freq
# Purpose: calculate the frequency of each codon in a given sequence.
# Input paramater: 1 string, the coding sequence.
# Returns: an hash where the keys are the codons and the values are
# the corresponding frequencies.


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


