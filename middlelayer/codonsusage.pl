### THIS SCRIPT CALCULATE BOTH FREQUENCIES AND USAGE RATIO FOR CODONS IN A CODING SEQUENCE ####

use strict;
use warnings;

# It starts by creating an array with all codons of a given coding sequence;
# I will need a string with the extracted and joined coding sequence (exons) for an entry.
# It also creates a second array for the translated sequence; each value is a single amino acid from 
# the translated sequence; the translated sequence should be easily
# retrievable from the database.

my $nucleo_seq = <>;
my $aa_seq = <>;


my @codons = $nucleo_seq =~ /[A-Z]{3}/gi;

my @aminos = $aa_seq =~ /[A-Z\*]/gi;
#Note from Richard[06/03/2016_00:47]: STOP codon(TAA,TGA,TAG) are denoted in aa sequnce as '*' so a backslashed asterix should
#be included in the aa characterset. 

# Below I calculate the frequency of each codon within the coding regions of an entry;
# To do this I need to count how many of each codon there are in the coding sequence; I do it by iterating
# my codon array and counting each codon with an hash;
# Then I use the total number of codon, which is the size of my initial codon array, to
# calculate the percentage of each codon.


##### THIS MECHANISM CAN ALSO BE USED TO CALCULATE THE CODON FREQUENCY IN THE WHOLE CHROMOSOME ####
##### TO DO THAT I WILL NEED AN SQL QUERY WHICH PASS ME ALL SEQUENCES IN AN ARRAY WHERE ####
##### EACH VALUES IS A SEQUENCE OF THE CHROMOSOME####
##### THAT WAY I CAN ITERATE THROUGH THE ARRAY AND CONCATENATE EACH CODING SEQUENCE AS A VERY LONG STRING ####
##### THEN I CAN TREAT IT THE SAME WAY AS A SMALL SEQUENCE BY DIVIDING IT IN CODONS AND ####
##### MAKING AN HASH WITH EACH CODON COUNT AND THEN CALCULATE THE FREQUENCY USING THE TOTAL NUMBER OF CODONS ####
#### IN THE CHROMOSOME.####

my %codon_count;



foreach my $codon (@codons)   {
   $codon_count{$codon}++;
}




my $codons_total = scalar(@codons);

print "Codons Frequency:\n";

foreach my $cod (keys %codon_count)   {
   my $frequency = ($codon_count{$cod} * 100) / $codons_total;
   print "$cod = $frequency\n";
}


# Now I create an hash to count how many of each amino acid type there are in the translated sequence.
# I need this count because for the usage ratio I need to know essentialy 3 things:
# How many of each codon type there are, how many of its corresponding amino acid there are
# and most importantly which one is the corresponding amino acid for a codon, which is resolved in the next step.

my %aa_count;

foreach my $value (@aminos)   {
    $aa_count{$value}++;
}


# In the 2 lines below I join my 2 original arrays in an hash called translation; this is useful because
# eack key in the hash will be a codon (so no duplicates), while each value will be
# the amino acid which each codon translate. This way I can use this new hash to connect
# each codon count to the correspondin amino acid count;
# for my calculation i simply calculate the ratio by using the total number of each codon type and
# the total number of its corresponding amino acid; i.e. a codon encoding Tyr could appear 3 times, while in
# the translated sequence there are 10 Tyr. This means that the other 7 Tyr are encoded by others codons.
# SO I use this informations for my calculation.

my %translation;


@translation{@codons} = @aminos;

print "Codons ratio:\n";

foreach my $codon (keys %translation)   {
   my $ratio = ($codon_count{$codon} * 100) / ($aa_count{$translation{$codon}});
   print "$codon = $translation{$codon} = $ratio\n";
}
