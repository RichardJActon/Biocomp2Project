#!/usr/bin/perl
use strict;
########################### CGI ############################
use CGI;
use middle::queries;
use middle::calculations;
use middle::codons;

my $cgi = new CGI;
print $cgi->header();

########################### DBI ############################
use DBI;

my $dbname = "Chromosome17";
my $dbhost = "hope";
my $dbsource = "dbi:mysql:database=$dbname;host=$dbhost";

#Database username and password is optional
my $username = "database-user";
my $password = "database-password";

$dbh = DBI->connect($dbsource17, $username, $password);
#############################################################

#This script is called on when a radio button is clicked 
#on and submitted in the results page displayed through 
#the first cgi script(proj(cgi).pl) 

my $specific_gene = $cgi->param('specific_gene');

print <<__EOF;

<html>
<head>
<style type='text/css'>

<!--
body { background: #5F9EA0;
       color: black; }
h1   { color: black;
	font-family: calibri; 
	font-size: 100%;  }
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

#Hash formed using subroutine from queries.pm module wherein the 
#key is the exon start position and the value is the exon length

my %exons = make_exons_hash($specific_gene);

#Both the nucleotide sequence and amino acid sequence extracted 
#using a subroutine which is also in the queries.pm module


my $nucleo_seq = get_sequences($specific_gene);
my $aa_seq = get_sequences($specific_gene);



foreach my $key (keys %exons){
	substr($nucleo_seq, $key, $exons{$key} =
	"<div style="color:0000FF">"
	.substr($nucleo_seq,$key,$exons{$key})
	"</div>";
}

#Prints the newly highlighted DNA sequence in sets of 
#50 nucleotides per line


print "<head> DNA sequence with coding regions highlighted: </head>
<br />"

"$_\n" for unpack '(A50)*', $nucleo_seq;

#Amino acid sequence processed using the protein spacing subroutine
#in the calculations.pm module. The purpose of this process is purely 
#for presentation of the coding sequence and the amino acid formed from
#triplet codon.

my $spaced_seq = protein_spacing($aa_seq);

<h2><b>
Amino acid Sequence with DNA Sequence
</h2></b>


my $coding_seq = connect_exons($Specific_gene);


<h3><b>
Codon usage frequencies
</b></h3>


print <<__EOF;
</body>
</html>

__EOF
