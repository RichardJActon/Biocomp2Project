#!/usr/bin/perl
use strict;
####################################### CGI ############################################
use CGI;
use lib '/d/user6/ad002/Middlelayer';
use middle::queries;
use middle::enzymes;

my $cgi = new CGI;
print $cgi->header();

#########################################################################################
#				CGI script #3 											
# This script creates a page to display the results of whether the user's motif is   	
# able to cut the DNA sequence at the 5' and/or 3' end.									
#########################################################################################

my $motif = $cgi -> param('motif');
my $specific_gene = $cgi->param('specific_gene');

print <<__EOF;
<html>
<head>
<style type='text/css'>
<!--
body	{background: #5F9EA0;
     	color: black; 
	font-family: Verdana
}
h1  	{color: black;
		font-family: verdana; 
		font-size: 100%;  
}
b 		{color: yellow;
}	
-->
</head>
</style>
<body>
<p align ='center'>
<a href="http://student.cryst.bbk.ac.uk/~ad002/projhome.html">
<span title="Home page"><img src ='http://student.cryst.bbk.ac.uk/~ad002/ch17logo2.png' width='50%' height='9%'alt='Explore Chromosome 17' /></span>
</a>
</p>
<br />
<h2>Check Restriction sequence</h2>
__EOF


#########################################################################################
# Reproducing the 3 regions of the gene sequence by calling the required functions	 	
#########################################################################################

my %exons = middle::queries::make_exons_hash($specific_gene);
my ($nucleo_seq, $aa_seq) = middle::queries::get_sequences($specific_gene);
my ($five_end, $middle_sect, $three_end) = middle::enzymes::get_regions($nucleo_seq, %exons);


my $complem_motif = middle::enzymes::get_complementary($motif);

if (middle::enzymes::check_enzyme($five_end, $middle_sect, $three_end, $motif, $complem_motif)){
	print "<p><b>$motif</b> can be used to cut the DNA sequence at both the 5' and 3' end, but not in between. </p>";
}else{
	print "<p><b>$motif</b> cannot cut the DNA sequence at the 5 and 3 end and not in between. </p>";
}


print <<__EOF;
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
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
</body>
</html>
__EOF
