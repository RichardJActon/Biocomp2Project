#!/usr/bin/perl
use strict;
####################################### CGI ############################################
use CGI;
use lib '/d/user6/ad002/Middlelayer';
use middle::queries;
use middle::cal;
use middle::codons;
use middle::enzymes;


my $cgi = new CGI;
print $cgi->header();

#########################################################################################
#				CGI script #2 						
# The first CGI script (projcgi.pl) produces a web page with the results of the users   
# search. On this intial results page the user is given the option to view further 	
# details about the gene. The purpose of this script is to present these further 	
# details namely, highlighted coding regions, coding regions/amino acids and      	
# codon usage frequencies in a presentable manner.					
#########################################################################################   


my $specific_gene = $cgi->param('specific_gene');



print <<__EOF;
<html>
<head>
<style type='text/css'>
<!--
body	{background: #5F9EA0;
     	color: black; 
        font-family: courier;
}
h1  	{color: black;
		font-family: calibri; 
		  
}
h2  {color: black;
}
h3   {color: black;
}
b {color:blue;
}
tr:hover {background-color: #66CC66}
tr 	{background-color: #3366CC}
table, th, td {
   border: 2px solid black;
}	
[type="radio"] { display:none; }
tr:nth-child(even) {background-color: #66CC66}
th, td {
    padding: 8px;
    text-align: left;
}
#panel, .flip {
    font-size: 16px;
    padding: 10px;
    text-align: center;
    background-color: #606060;
    color: Black;
    border: solid 1px #a6d8a8;
    margin: auto;
}

#panel {
    display: none;
}
-->
</head>	
</style>
<p align ='center'>
<a href="http://student.cryst.bbk.ac.uk/~ad002/projhome.html">
<span title="Home page"><img src ='http://student.cryst.bbk.ac.uk/~ad002/ch17logo2.png' width='50%' height='9%'alt='Explore Chromosome 17' /></span>
</a>
</p>
<h1>Details for $specific_gene</h1>
<br />
<body>
<form method="post" action="http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/ad002/projcgi3.pl">
<br />
<br />
__EOF


#########################################################################################
#        		DNA Coding regions highlighted 					
# A hash is formed using a subroutine from the queries.pm module called make_exons_hash 
# wherein the hash key is the exon start position and the value of the hash is the      
# exon length. Both the nucleotide sequence and amino acid sequence are extracted using 
# a subroutine which is also found in the queries.pm module called get_sequences.       
# It is ideal to present this piece of detail before any other gene detail since the    
# other gene details such as coding regions/amino acids require the modification of 	
# the raw sequence.                                                                     
#   Note:                                                                               
#   Highlighting colour: blue                                                 
#	Number of nucleotides per line: 50 - [edit unpack (A50) to adjust]              
#########################################################################################

#########################################################################################
#				OPEN BIG IF STATEMENT					
if (middle::queries::make_exons_hash($specific_gene) and middle::queries::get_sequences($specific_gene))    {		
#########################################################################################



my %exons = middle::queries::make_exons_hash($specific_gene);
my ($nucleo_seq, $aa_seq, $reading) = middle::queries::get_sequences($specific_gene);
my $coding_seq = middle::cal::connect_exons($nucleo_seq, $reading, %exons);
my @exon_box = middle::cal::extract_exons($nucleo_seq, %exons);



foreach my $value (@exon_box)  {
$nucleo_seq =~ s!$value!<b>$value</b>!;
}

print "<h2> DNA sequence with coding regions highlighted: </h2><br />";

print "<p>$_</p>\n" for unpack '(A50)*', $nucleo_seq;


#########################################################################################
# 		DNA coding regions displayed alongside Amino acid Sequence 	
# Having extracted both the nucleotide DNA sequence and the amino acid sequence 	
# in the previous highlighting step, these sequences can now be modified using		
# subroutines from the calculations module namely connect_exons and protein_spacing.	
# Once modified the sequences are printed in the following fashion:			
#                          CUUACCAAAGAAAGUUGU						
#                          -L--T--K--E--S--S-						
#											
# with a clear newline after every pair of DNA sequence and amino acid sequence.	
#     Note:										
#     Number of nucleotides per line: 99 [edit ($seq_length = 99) to adjust]		
#     Amino acid colour: blue						
#########################################################################################







my $spaced_seq = middle::cal::protein_spacing($aa_seq);

print <<__EOF;
<br />
<h2>Coding Sequence with aligned amino acid sequence: </h2>
__EOF


my $upper_seq = uc($coding_seq);


my $start_pos = 0;
my $seq_length = 99;

while ($start_pos < length($coding_seq)) {
	print '<p>', substr ( $upper_seq, $start_pos, $seq_length), '</p>', "\n";
	print '<b>', substr( $spaced_seq, $start_pos, $seq_length), '</b>',"\n";
	print "<p> <p/>";

	$start_pos += $seq_length;
}



########################################################################################
#			 	Codon Usage information					
# Each codon frequency and codon ratio is displayed in a table. There are 3 functions 	
# which have been called from the codons.pm module in the middle layer in order to fill	
# the 3 columns in the table. Since the keys of the 3 hashes being returned from the 	
# middle layer are all codons, when they're sorted in alphabetical order, each value of 
# each hash will slot seamlessly into their respective positions in the table.  										
#########################################################################################

print <<__EOF;
<br />
<div id="Genetable" class="table">
<h2>Codon usage information in $specific_gene: </h2>
<br / >
<div style="overflow-x:auto;">

<table border ="2">
<tr >
<td><h3> Amino Acid </h3></td>
<td><h3> Codon </h3></td>
<td><h3> Codon Frequency %</h3> </td>
<td><h3> Codon Ratio %</h3></td>
</tr>
__EOF

my %codon_freq = middle::codons::calc_cod_freq($coding_seq);
my %codon_ratio = middle::codons::calc_cod_ratio($coding_seq, $aa_seq);
my %translation = middle::codons::map_codons($coding_seq, $aa_seq);


foreach my $codon (sort keys %codon_freq){
	print <<__EOF;
		<tr>
		<td>$translation{$codon}</td>
		<td>$codon</td>
		<td>$codon_freq{$codon} </td>
		<td>$codon_ratio{$codon} </td>
		</tr>
__EOF
}
#########################################################################################
#
#	Precalculated Codon usage frequencies and codon usage ratios for chromosome 17
#
#########################################################################################

print <<__EOF;
</table>
</div>
<br / >
<div id="Chromosometable" class="table">
<h2>Codon usage information for Chromosome 17: </h2>
<br / >
<div style="overflow-x:auto;">
<table border ="2">
<tr >
<td><h3> Amino Acid </h3></td>
<td><h3> Codon </h3></td>
<td><h3> Codon Frequency %</h3> </td>
<td><h3> Codon Ratio %</h3></td>
</tr>
<tr><td>Lysine</td><td>aaa</td><td>1.59</td><td>45.91</td></tr>
<tr><td>Aspargine</td><td>aac</td><td>1.18</td><td>54.32</td></tr>
<tr><td>Lysine</td><td>aag</td><td>1.88</td><td>54.09</td></tr>
<tr><td>Aspargine</td><td>aat</td><td>1.00</td><td>45.68</td></tr>
<tr><td>Tryptophan</td><td>aca</td><td>1.47</td><td>18.05</td></tr>
<tr><td>Tryptophan</td><td>acc</td><td>1.83</td><td>22.53</td></tr>
<tr><td>Tryptophan</td><td>acg</td><td>0.80</td><td>9.83</td></tr>
<tr><td>Tryptophan</td><td>act</td><td>1.22</td><td>15.04</td></tr>
<tr><td>Arginine</td><td>aga</td><td>2.17</td><td>25.67</td></tr>
<tr><td>Serine</td><td>agc</td><td>2.38</td><td>24.72</td></tr>
<tr><td>Arginine</td><td>agg</td><td>2.45</td><td>28.93</td></tr>
<tr><td>Serine</td><td>agt</td><td>1.08</td><td>11.27</td></tr>
<tr><td>Isoleucine</td><td>ata</td><td>0.57</td><td>22.08</td></tr>
<tr><td>Isoleucine</td><td>atc</td><td>1.06</td><td>41.55</td></tr>
<tr><td>Methionine</td><td>atg</td><td>1.50</td><td>100.00</td></tr>
<tr><td>Isoleucine</td><td>att</td><td>0.93</td><td>36.37</td></tr>
<tr><td>Glutamine</td><td>caa</td><td>1.65</td><td>38.56</td></tr>
<tr><td>Histidine</td><td>cac</td><td>1.50</td><td>56.20</td></tr>
<tr><td>Glutamine</td><td>cag</td><td>2.62</td><td>61.44</td></tr>
<tr><td>Histidine</td><td>cat</td><td>1.17</td><td>43.80</td></tr>
<tr><td>Proline</td><td>cca</td><td>2.57</td><td>27.28</td></tr>
<tr><td>Proline</td><td>ccc</td><td>2.76</td><td>29.27</td></tr>
<tr><td>Proline</td><td>ccg</td><td>1.33</td><td>14.08</td></tr>
<tr><td>Proline</td><td>cct</td><td>2.77</td><td>29.37</td></tr>
<tr><td>Arginine</td><td>cga</td><td>0.73</td><td>8.68</td></tr>
<tr><td>Arginine</td><td>cgc</td><td>1.19</td><td>14.10</td></tr>
<tr><td>Arginine</td><td>cgg</td><td>1.28</td><td>15.07</td></tr>
<tr><td>Arginine</td><td>cgt</td><td>0.64</td><td>7.55</td></tr>
<tr><td>Leucine</td><td>cta</td><td>0.83</td><td>9.17</td></tr>
<tr><td>Leucine</td><td>ctc</td><td>2.02</td><td>22.41</td></tr>
<tr><td>Leucine</td><td>ctg</td><td>2.92</td><td>32.42</td></tr>
<tr><td>Leucine</td><td>ctt</td><td>1.45</td><td>16.06</td></tr>
<tr><td>Glutamic Acid</td><td>gaa</td><td>1.83</td><td>44.16</td></tr>
<tr><td>Aspartic Acid</td><td>gac</td><td>1.38</td><td>53.67</td></tr>
<tr><td>Glutamic Acid</td><td>gag</td><td>2.31</td><td>55.84</td></tr>
<tr><td>Aspartic Acid</td><td>gat</td><td>1.19</td><td>46.33</td></tr>
<tr><td>Alanine</td><td>gca</td><td>1.95</td><td>24.05</td></tr>
<tr><td>Alanine</td><td>gcc</td><td>2.64</td><td>32.65</td></tr>
<tr><td>Alanine</td><td>gcg</td><td>1.18</td><td>14.61</td></tr>
<tr><td>Alanine</td><td>gct</td><td>2.32</td><td>28.69</td></tr>
<tr><td>Glycine</td><td>gga</td><td>2.54</td><td>29.85</td></tr>
<tr><td>Glycine</td><td>ggc</td><td>2.31</td><td>27.18</td></tr>
<tr><td>Glycine</td><td>ggg</td><td>2.35</td><td>27.62</td></tr>
<tr><td>Glycine</td><td>ggt</td><td>1.31</td><td>15.35</td></tr>
<tr><td>Valine</td><td>gta</td><td>0.64</td><td>14.21</td></tr>
<tr><td>Valine</td><td>gtc</td><td>1.09</td><td>24.37</td></tr>
<tr><td>Valine</td><td>gtg</td><td>1.91</td><td>42.64</td></tr>
<tr><td>Valine</td><td>gtt</td><td>0.84</td><td>18.79</td></tr>
<tr><td>Stop</td><td>taa</td><td>0.68</td><td>21.78</td></tr>
<tr><td>Tyrosine</td><td>tac</td><td>0.77</td><td>51.24</td></tr>
<tr><td>Stop</td><td>tag</td><td>0.56</td><td>17.79</td></tr>
<tr><td>Tyrosine</td><td>tat</td><td>0.73</td><td>48.76</td></tr>
<tr><td>Serine</td><td>tca</td><td>1.54</td><td>15.98</td></tr>
<tr><td>Serine</td><td>tcc</td><td>2.33</td><td>24.26</td></tr>
<tr><td>Serine</td><td>tcg</td><td>0.71</td><td>7.37</td></tr>
<tr><td>Serine</td><td>tct</td><td>1.58</td><td>16.40</td></tr>
<tr><td>Stop</td><td>tga</td><td>1.89</td><td>60.44</td></tr>
<tr><td>Cysteine</td><td>tgc</td><td>1.98</td><td>60.63</td></tr>
<tr><td>Tryptophan</td><td>tgg</td><td>2.81</td><td>34.55</td></tr>
<tr><td>Cysteine</td><td>tgt</td><td>1.29</td><td>39.37</td></tr>
<tr><td>Leucine</td><td>tta</td><td>0.63</td><td>6.94</td></tr>
<tr><td>Phenylananine</td><td>ttc</td><td>1.48</td><td>51.04</td></tr>
<tr><td>Leucine</td><td>ttg</td><td>1.17</td><td>12.99</td></tr>
<tr><td>Phenylananine</td><td>ttt</td><td>1.42</td><td>48.96</td></tr>
</table>
__EOF

#########################################################################################
#				Restriction Enzymes 					
# The 5', middle section and 3' regions of the sequence are separated using the 	
# get_regions function in the enzymes.pm module. Each of the restriction site Enzymes 	
# are then checked against the gene DNA sequence to identify whether any 		
# restriction sites are present in the sequence.					
#########################################################################################

print <<__EOF;
</div>
</div>
<br />
<h2>Restriction Enzymes: </h2>
__EOF


my ($five_end, $middle_sect, $three_end) = middle::enzymes::get_regions($nucleo_seq, %exons);

if (middle::enzymes::check_ecori($five_end, $middle_sect, $three_end)){

	print "<p> There are restrictions sites for the enzyme ECORI at the 5 and 3 end and not in between. </p>";

}else{

	print "<p> ECORI is not able to cut the sequence at the 5 and 3 end and not in between. </p>";
}


if (middle::enzymes::check_bamhi($five_end, $middle_sect, $three_end)){

	print "<p> There are restriction sites for the enzyme BAMHI at the 5 and 3 end and not in between. </p>";

}else{

	print "<p> BAHMI is not able to cut the sequence at the 5 and 3 end and not in between. </p>";
}


if (middle::enzymes::check_bsumi($five_end, $middle_sect, $three_end)){

	print "<p> There are restriction sites for the enzyme BSUMI at the 5 and 3 end and not in between. </p>";

}else{

	print "<p> BSUMI is not able to cut the sequence at the 5 and 3 end and not in between. </p>";
}

#########################################################################################
# In order to carry over the gene sequence to the 3rd CGI script an automatically 	
# checked radio button is implemented and is hidden using css.				
#########################################################################################


print <<__EOF;
<br/>
<p align='center'>
<img src ="http://student.cryst.bbk.ac.uk/~ad002/restrenzyme.jpg" width="25%" height="25%"alt="browser_unsupported_image" border='1' style="border-color:blue" />
</p>
<h2 align='center'>Check Restriction Sites </h2>
<p align='center'>Enter your sequence below to find out whether your sequence can cut the DNA in the 5' and/or 3' regions, but not in between. </p>
<br/ >
<p align='center'>
<input type='radio' name='specific_gene' value='$specific_gene' checked="yes"/>
<input type='text' name='motif' size='20'>
<input type='submit' value='CHECK'>
</p>
<br />
<br />
<br />
<br />
<p align='center'>
<a href="http://student.cryst.bbk.ac.uk/~ad002/aboutus.html">
<span title="Learn more"><img src='http://student.cryst.bbk.ac.uk/~ad002/aboutus.png' width='10%' height='5%' border='1' style="border-color:blue" /><span>
</a>
<a href="http://blast.ncbi.nlm.nih.gov/Blast.cgi">
<span title="Blast"><img src='http://student.cryst.bbk.ac.uk/~ad002/blast.jpg' width='10%' height='5%' border='1' style="border-color:white" /><span>
</a> 
<a href="http://www.ebi.ac.uk/Tools/msa/clustalo/">
<span title="Multiple sequence alignment"><img src='http://student.cryst.bbk.ac.uk/~ad002/embl.png' width='10%' height='5%' border='1' style="border-color:transparent" /><span>
</a>
<a href="http://rnaanalyzer.bioapps.biozentrum.uni-wuerzburg.de/server.html">
<span title="RNA Analyser"><img src='http://student.cryst.bbk.ac.uk/~ad002/RNAanalyser.jpeg' width='10%' height='5%' border='1' style="border-color:transparent" /><span>
</a>
<p>
__EOF

#########################################################################################
#				CLOSE BIG IF STATEMENT					
											
}else{										
											
print "<p> Unfortunately there is no sequence data avaialble for $specific_gene </p>";
										
}											
#########################################################################################
print <<__EOF;
</form>
</body>
</html>
__EOF
