# This script carries the codons frequency and ratio calculations on the whole chromosome.
# The text file containing the concatenated coding sequences need to be passed to this script.
# The script first calculates codons frequencies using a subroutine from the module codons.pm
# I could not use the subroutine I made for the codons ratio, as that subroutine would not
# properly account for Stop codons if used for calculations in the whole chromosome.
# I also avoided extracting the protein data from the database, but I re-calculated it in this
# script using the full coding sequence; I have used this method to avoid associating a coding
# sequence to the wrong protein, due to the high number of exceptions and missing data in the database.
# In this script for the codons ratio calculations I first built a long translated protein sequence by converting each
# codon in the all_coding string I have extracted with the script extract.pl
# Once I have created the protein, I calculated ratios the same way as I did in codons.pm, 
# with an exception in the way I handled stop codons, as I need to account for a stop codon
# in each sequence; this is also another reason why I decided to re-calculate the protein.
# This script prints into a file the codons frequencies and ratios with appropriate
# html table tags agreed with the front end, ready to be pasted into html.

use strict;
use warnings;
use lib '/d/user6/ng001/Middlelayer';
use middle::codons;

my $fname = $ARGV[0];
my $fname2 = $ARGV[1];

open(INFILE, "$fname")
     or die "Can't open file $fname\n";

open(OUTFILE, ">$fname2")
     or die "Can't open file $fname2\n";

my $all_coding = <INFILE>;

my @codons = $all_coding =~ /[A-Z]{3}/gi;

my $all_proteins = "";

foreach my $value (@codons)   {

    if ($value =~ /ttt|ttc/)   {
    $all_proteins .= 'F'
   }
    elsif ($value =~ /tta|ttg/)   {
    $all_proteins .= 'L'
   }
    elsif ($value =~ /ctc|ctt|cta|ctg/)   {
    $all_proteins .= 'L'
   }
    elsif ($value =~ /att|ata|atc/)   {
    $all_proteins .= 'I'
   }
    elsif ($value =~ /atg/)   {
    $all_proteins .= 'M'
   }
    elsif ($value =~ /gtt|gtc|gta|gtg/)   {
    $all_proteins .= 'V'
   }
    elsif ($value =~ /tct|tcc|tca|tcg/)   {
    $all_proteins .= 'S'
   }
    elsif ($value =~ /cct|ccc|cca|ccg/)   {
    $all_proteins .= 'P'
   }
    elsif ($value =~ /act|acc|aca|acg/)   {
    $all_proteins .= 'W'
   }
    elsif ($value =~ /gct|gcc|gca|gcg/)   {
    $all_proteins .= 'A'
   }
    elsif ($value =~ /taa|tag|tga/)   {
    $all_proteins .= 'J'
   }
    elsif ($value =~ /cat|cac/)   {
    $all_proteins .= 'H'
   }
    elsif ($value =~ /caa|cag/)   {
    $all_proteins .= 'Q'
   }
    elsif ($value =~ /aat|aac/)   {
    $all_proteins .= 'N'
   }
    elsif ($value =~ /aaa|aag/)   {
    $all_proteins .= 'K'
   }
    elsif ($value =~ /gat|gac/)   {
    $all_proteins .= 'D'
   }
    elsif ($value =~ /gaa|gag/)   {
    $all_proteins .= 'E'
   }
    elsif ($value =~ /tgt|tgc/)   {
    $all_proteins .= 'C'
   }
    elsif ($value =~ /tgg/)   {
    $all_proteins .= 'W'
   }
    elsif ($value =~ /cgt|cgc|cga|cgg/)   {
    $all_proteins .= 'R'
   }
    elsif ($value =~ /agt|agc/)   {
    $all_proteins .= 'S'
   }
    elsif ($value =~ /aga|agg/)   {
    $all_proteins .= 'R'
   }
    elsif ($value =~ /ggt|ggc|gga|ggg/)   {
    $all_proteins .= 'G'
   }
    elsif ($value =~ /tat|tac/)   {
    $all_proteins .= 'Y'
   }
    else   {
    $all_proteins .= 'X'
   }

}





my %freq;

%freq = middle::codons::calc_cod_freq($all_coding);






  my @aminos = $all_proteins =~ /[A-Z\*]/gi;
  


  foreach my $value (@aminos)   {
  
    if ($value eq 'A')  {
       $value = "Alanine";
   }
    elsif ($value eq 'C')  {
       $value = "Cysteine";
   }
    elsif ($value eq 'D')  {
       $value = "Aspartic Acid";
   }
    elsif ($value eq 'E')  {
       $value = "Glutamic Acid";
   }
    elsif ($value eq 'F')  {
       $value = "Phenylananine";
   }
    elsif ($value eq 'G')  {
       $value = "Glycine";
   }
    elsif ($value eq 'H')  {
       $value = "Histidine";
   }
   elsif ($value eq 'I')  {
       $value = "Isoleucine";
   }
    elsif ($value eq 'K')  {
       $value = "Lysine";
   }

    elsif ($value eq 'L')  {
       $value = "Leucine";
   }
    elsif ($value eq 'M')  {
       $value = "Methionine";
   }
    elsif ($value eq 'N')  {
       $value = "Aspargine";
   }
    elsif ($value eq 'P')  {
       $value = "Proline";
   }
    elsif ($value eq 'Q')  {
       $value = "Glutamine";
   }
    elsif ($value eq 'R')  {
       $value = "Arginine";
   }
    elsif ($value eq 'S')  {
       $value = "Serine";
   }
    elsif ($value eq 'T')  {
       $value = "Threonine";
   }
    elsif ($value eq 'V')  {
       $value = "Valine";
   }
    elsif ($value eq 'W')  {
       $value = "Tryptophan";
   }
    elsif ($value eq 'Y')  {
       $value = "Tyrosine";
   }
    elsif ($value eq 'X')  {
       $value = "Undetermined";
   }
    elsif ($value eq 'J')  {
       $value = "Stop";
   }
}
  my %translation;

  @translation{@codons} = @aminos;



foreach my $key (keys %translation)  {
if ($key !~ /n/g)  {
print OUTFILE "$key = $translation{$key}\n";
}
}





   my %aa_count;

   foreach my $value (@aminos)   {
     $aa_count{$value}++;
   }

   my %cod_count;

   foreach my $value (@codons)   {
      $cod_count{$value}++;
   }




   my %codonratio;

   foreach my $codon (keys %translation)   {
      my $ratio = ($cod_count{$codon} * 100) / ($aa_count{$translation{$codon}});
         $ratio = sprintf("%.2f", $ratio);
         $codonratio{$codon} = $ratio;
   }

# The if statement in the for loop below is to get rid of undetermined codons containing
# unwanted characters. Some of these characters do have meaning, but do not represents
# real codons therefore we avoided showing them.

foreach my $key (sort keys %codonratio)  {
   if ($key !~ /n|m|k|r/g)  {
       print OUTFILE "<tr><td>$translation{$key}</td><td>$key</td><td>$freq{$key}</td><td>$codonratio{$key}</td></tr>\n";
   }
}
