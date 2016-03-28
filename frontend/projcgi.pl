#!/usr/bin/perl
use strict;
####################################### CGI ############################################
use CGI;
use middle::queries;

my $cgi = new CGI;
print $cgi->header();

#########################################################################################
#									CGI script #1										#
# The purpose of this CGI script is to pass the 2 inputs (search type and the gene id)  #
# entered by the user through a subroutine in the firsquery.pm module which then        #
# uses it to query the database for the relevant data i.e. an alternative               #
# identification for the gene the gene.                                                 #
#########################################################################################

my $search_type = $cgi->param('search_type');

my $user_input = $cgi->param('user_input');
	 
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
<title>Search result(s)</title>
</head>	
</style>

<body>
<form method="post" action="http://student.cryst.bbk.ac.uk/ad002/WWW/cgi-bin/proj(cgi2).pl">
<br />
<br />
<table border ="1">
	<tr>
	<td><b>Accessions</b></td>
	<td><b>ID----Protein----Location</b></td>
	<td><b>Select Gene<b><td>
	</tr>

__EOF

#########################################################################################
#								Initial results page				 					#
# Upon capturing the user's 2 inputs, namely search_type & user_input, these 2 strings	#
# are passed as arguments through the subroutine called get_results which is in the 	#
# firstquery.pm module. The result page displays alternative gene identifiers.			#
# Assuming the user may use chromosomal location as a gene id, the following script		#
# accounts for multiple genes by displaying the genes in a tabular format with the 		#
# option of choosing a specific gene.													#
#########################################################################################


if (get_results($search_type, $user_input)   {

   my %results = get_results($search_type, $user_input);


   foreach my $accession_key (sort keys %results){
	print   "<tr>";
	print	"<td> $accession_key </td>";
	print	"<td> $results{$accession_key} </td>";
	print	"<td><input type='radio' name='specific_gene' value='$accession_key'/></td> </tr>";
   }

}

else   {


    print "<p> Your search did not find any result<p>";

}


print <<__EOF;
</table>
<br />
<br />
<input type='submit' value='SUBMIT' />
</form>
</body>
</html>"

__EOF
