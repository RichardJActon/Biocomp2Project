#!/usr/bin/perl
use strict;
####################################### CGI ############################################
use CGI;
use middle::queries;
use middle::calculations;
use middle::codons;

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
}

h1  	{color: black;
		font-family: calibri; 
		font-size: 100%;  
}

b 		{color: #FF0000;
}	
-->
<title>Details of Gene: $specific_gene</title>
</head>	
</style>

<h1><b>
DNA Sequence with coding regions highlighted
</b></h1>
<body>
<br />
<br />

__EOF


#########################################################################################
#        			DNA Coding regions highlighted 				#
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

my %exons = make_exons_hash($specific_gene);

my ($nucleo_seq, $aa_seq) = get_sequences($specific_gene);



my @exon_box = extract_exons($nucleo_seq, %exons);



foreach my $value (@exon_box)  {
$nucleo_seq =~ s!$value!<b>$value</b>!;
}

print "<h1> DNA sequence with coding regions highlighted: </h1><br />";

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
#     Number of nucleotides per line: 50 [edit ($coding_seq, 0, 50) to adjust]		#
#     Amino acid colour: #FF0000 = red							#
#########################################################################################
#The code below is not working as it should. Working on correcting it.                  #
#											#
#########################################################################################
my $coding_seq = connect_exons($nucleo_seq, %exons);

my $spaced_seq = protein_spacing($aa_seq);

print <<__EOF;
<h2><b>
Coding Sequence with respective amino acid sequence
</b></h2>
<br />
__EOF


print "<h3> The coding DNA sequence: </h3>
<br />"

print "<p>$_</p>\n" for unpack '(A50)*', $coding_seq;

print "<br />
<h4> The amino acid sequence: </h4>
<br />"

print "<p>$_</p>\n" for unpack '(A50)*', $spaced_seq;



<h3><b>
Codon usage frequencies
</b></h3>


print <<__EOF;
</body>
</html>

__EOF

