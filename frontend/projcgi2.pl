#!/usr/bin/perl
use strict;
####################################### CGI ############################################
use CGI;
use lib '/d/user6/ng001/Middlelayer';
use middle::queries;
use middle::cal;
use middle::codons;
use middle::enzymes;


my $cgi = new CGI;
print $cgi->header();

#########################################################################################
#				CGI script #2 						#
# The first CGI script (projcgi.pl) produces a web page with the results of the users   #
# search. On this intial results page the user is given the option to view further 	#
# details about the gene. The purpose of this script is to present these further 	#
# details namely, highlighted coding regions, coding regions/amino acids and      	#
# codon usage frequencies in a presentable manner.					#
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
b {color:yellow;
}
	
[type="radio"] { display:none; }
-->
<title>Details of Gene</title>
</head>	
</style>
<h1>Details for $specific_gene</h1>
<body>
<form method="post" action="http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/ng001/projcgi3.pl">
<br />
<br />
__EOF


#########################################################################################
#        		DNA Coding regions highlighted 					#
# A hash is formed using a subroutine from the queries.pm module called make_exons_hash #
# wherein the hash key is the exon start position and the value of the hash is the      #  
# exon length. Both the nucleotide sequence and amino acid sequence are extracted using #
# a subroutine which is also found in the queries.pm module called get_sequences.       #
# It is ideal to present this piece of detail before any other gene detail since the    #
# other gene details such as coding regions/amino acids require the modification of 	#
# the raw sequence.                                                                     #
#   Note:                                                                               #
#   Highlighting colour: #FF0000 = red                                                  #
#	Number of nucleotides per line: 50 - [edit unpack (A50) to adjust]              # 
#########################################################################################

#########################################################################################
#				OPEN BIG IF STATEMENT					#
if (middle::queries::make_exons_hash($specific_gene) and middle::queries::get_sequences($specific_gene))    {		#
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
# 		DNA coding regions displayed alongside Amino acid Sequence 		#
# Having extracted both the nucleotide DNA sequence and the amino acid sequence 	#
# in the previous highlighting step, these sequences can now be modified using		#
# subroutines from the calculations module namely connect_exons and protein_spacing.	#
# Once modified the sequences are printed in the following fashion:			#
#                          CUUACCAAAGAAAGUUGU						#
#                          -L--T--K--E--S--S-						#
#											#
# with a clear newline after every pair of DNA sequence and amino acid sequence.	#
#     Note:										#
#     Number of nucleotides per line: 101 [edit ($seq_length = 101) to adjust]		#
#     Amino acid colour: #FF0000 = red							#
#########################################################################################







my $spaced_seq = middle::cal::protein_spacing($aa_seq);

print <<__EOF;
<h2>Coding Sequence with aligned amino acid sequence: </h2>
__EOF


my $upper_seq = uc($coding_seq);


my $start_pos = 0;
my $seq_length = 101;

while ($start_pos < length($coding_seq)) {
	print '<p>', substr ( $upper_seq, $start_pos, $seq_length), '</p>', "\n";
	print '<b>', substr( $spaced_seq, $start_pos, $seq_length), '</b>',"\n";
	print "<p> <p/>";

	$start_pos += $seq_length;
}



########################################################################################
#			 	Codon Usage information					#
# Each codon frequency and codon ratio is displayed in a table. There are 3 functions 	#
# which have been called from the codons.pm module in the middle layer in order to fill	#
# the 3 columns in the table. Since the keys of the 3 hashes being returned from the 	#
# middle layer are all codons, when they're sorted in alphabetical order, each value of #
# each hash will slot seamlessly into their respective positions in the table.  	#										
#########################################################################################

print <<__EOF;
<h2>Codon usage information: </h2>
<br / >

<table border ="2">
<tr>
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
#				Restriction Enzymes 					#
# The 5', middle section and 3' regions of the sequence are separated using the 	#
# get_regions function in the enzymes.pm module. Each of the restriction site Enzymes 	#
# are then checked against the gene DNA sequence to identify whether any 		#
# restriction sites are present in the sequence.					#
#########################################################################################

print <<__EOF;
</table>
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
# In order to carry over the gene sequence to the 3rd CGI script an automatically 	#
# checked radio button is implemented and is hidden using css.				#
#########################################################################################


print <<__EOF;
<p align='center'>
<img src ="http://imageshack.com/a/img923/1176/35F89f.gif" width="25%" height="25%"alt="browser_unsupported_image" />
</p>
<h2 align='center'>Check Restriction Sites Sequence </h2>
<p align='center'>Enter your sequence below to find out whether your sequence can cut the DNA in the 5' and/or 3' regions and not in between. </p>
<br/ >
<p align='center'>
<input type='radio' name='specific_gene' value='$specific_gene' checked="yes"/>
<input type='text' name='motif' size='20'>
<input type='submit' value='CHECK'>
</p>
__EOF

#########################################################################################
#				CLOSE BIG IF STATEMENT					#
											#
}else{											#
											#
print "<p> Unfortunately there is no sequence data avaialble for $specific_gene </p>";
											#
}											#
#########################################################################################
print <<__EOF;
</form>
</body>
</html>
__EOF





