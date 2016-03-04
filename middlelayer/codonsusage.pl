use strict;
use warnings;

# This is just a simple script to divide the coding sequence into codons
# and to divide the translated sequence in single amino acids;
# I will need to find a way to merge the two arrays.

my $nucleo_seq = <>;
my $aa_seq = <>;


my @codons = $nucleo_seq =~ /[A-Z]{3}/gi;

foreach my $codon (@codons)   {
   print "$codon\n";
}


my @aminos = $aa_seq =~ /[A-Z]/gi;

foreach my $aa (@aminos)   {
   print $aa . "\n";
}

