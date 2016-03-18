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

$dbh = DBI->connect($dbsource, $username, $password);
#############################################################

#This script is called on when a radio button is clicked 
#on and submitted in the results page displayed through 
#the first cgi script(proj(cgi).pl) 

my $specific_gene = $cgi->param('Specific_gene');

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
#0000FF = blue

# this is how you call this function: 
my ($nucleo_seq, $aa_seq) = get_sequences($specific_gene);

my $line_count = 0;

foreach my $key (keys %exons){
	substr($nucleo_seq, $key, $exons{$key} =
	"<div style="color:0000FF">"
	.substr($nucleo_seq,$key,$exons{$key})
	"</div>";
}

#Prints the newly highlighted DNA sequence in sets of 
#50 nucleotides per line


print "<h1> DNA sequence with coding regions highlighted: </h1>
<br />"

"$_\n" for unpack '(A50)*', $nucleo_seq;

#Coding sequence extracted using a module from the calculations.pm module
#DNA

my $coding_seq = connect_exons($nucleo_seq, %exons);

#Amino acid sequence processed using the protein spacing subroutine
#in the calculations.pm module. The purpose of this process is purely 
#for presentation of the coding sequence and the amino acid formed from
#triplet codon.

my $spaced_seq = protein_spacing($aa_seq);

#Both the DNA coding sequence printed line by line to show which triplet
#code of the coding sequence is coupled with which amino acid
#FF0000 = red

print <<__EOF;
<h2><b>
Coding Sequence with respective amino acid sequence
</b></h2>

__EOF

my $coding_length = length($coding_seq);
my $spaced_length = length($spaced_seq);

for (my $i = 0; $i<$coding_length; $i++){
	if ($coding_length > 0){
			$coding_seq = substr ($coding_seq, 0, 50);
				print "$coding_seq \n";
		}
for (my $i = 0; $i<$spaced_length; $i++){
	}
		if ($spaced_length > 0){
			$spaced_seq = substr ($spaced_seq, 0, 50);
				print "<div style="color:FF0000">$spaced_seq\n</div>";		
	}
}



<h3><b>
Codon usage frequencies
</b></h3>


print <<__EOF;
</body>
</html>

__EOF
