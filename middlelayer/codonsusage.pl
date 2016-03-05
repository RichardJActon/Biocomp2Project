use strict;
use warnings;

# It starts by creating an array with all codons of a sequence;
# I will need a string with the sequence from the sql query of an entry.

my $nucleo_seq = <>;
my $aa_seq = <>;


my @codons = $nucleo_seq =~ /[A-Z]{3}/gi;

my @aminos = $aa_seq =~ /[A-Z]/gi;


# Below I calculate the frequency of each codon within the coding regions of an entry;
# To do this I need to count how many of each codon there are; I do it by iterating
# my codon array and counting each codon with an hash;
# Then I use the total number of codon, which is the size of my initial codon array, to
# calculate the percentage of each codon.


##### THIS MECHANISM CAN ALSO BE USED TO CALCULATE THE CODON FREQUENCY IN THE WHOLE CHROMOSOME ####
##### TO DO THAT I WILL NEED AN SQL QUERY WHICH PASS ME ALL SEQUENCES IN AN ARRAY WHERE ####
##### EACH VALUES IS A SEQUENCE OF THE CHROMOSOME####
##### THE ARRAY; THAT WAY I CAN ITERATE THROUGH THE ARRAY AND CONCATENATE EACH CODING SEQUENCE AS A VERY LONG STRING ####
##### THEN I CAN TREAT IT THE SAME WAY AS I TRATED A SMALL SEQUENCE BY DIVIDING IT IN CODONS ####
##### MAKING AN HASH WITH EACH CODON COUNT AND THEN CALCULATE THE FREQUENCY USING THE TOTAL NUMBER OF CODONS ####
#### IN THE CHROMOSOME.

my %codon_count;



foreach my $codon (@codons)   {
   $codon_count{$codon}++;
}




my $codons_total = scalar(@codons);


foreach my $cod (keys %codon_count)   {
   my $frequency = ($codon_count{$cod} * 100) / $codons_total;
   print "$cod = $frequency\n";
}


# Now I need to find a way to calculate the ration of each codon encoding its corresponding amino acid.
