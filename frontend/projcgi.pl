#!/usr/bin/perl
use strict;
####################################### CGI ############################################
use CGI;
use lib '/d/user6/ad002/Middlelayer';
use middle::queries;

my $cgi = new CGI;
print $cgi->header();

#########################################################################################
#			            CGI script #1						                                
# The purpose of this CGI script is to pass the 2 inputs (search type and the gene id)  
# entered by the user through a subroutine in the firsquery.pm module which then        
# uses it to query the database for the relevant data i.e. an alternative               
# identification for the gene the gene.                                                 
#########################################################################################

my $search_type = $cgi->param('search_type');

my $user_input = $cgi->param('user_input');
	 
print <<__EOF;
<html>
<head>
<style type='text/css'>
<!--
body { background: #5F9EA0;
       color: black; 
	font-family: Verdana  }
h1   { color: black;
	font-family: Verdana; }
tr:hover {background-color: #66CC66}
tr 	{background-color: #3366CC}
table, th, td {
   border: 2px solid black;
}
-->
</head>	
</style>
<p align ='center'>
<a href="http://student.cryst.bbk.ac.uk/~ad002/projhome.html">
<span title="Home page"><img src ='http://imageshack.com/a/img924/3898/wDpGUM.png' width='50%' height='9%'alt='Explore Chromosome 17' /></span>
</a>
</p>
<body>
<form method="post" action="http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/ad002/projcgi2.pl">
<h1> Search Results: </h1>
<p>Please select a gene and enter.</p>
<br />

<br />
<div style="overflow-x:auto;">
<table border ="1">
	<tr>
	<td><b>GenBank Accession </b></td>
	<td><b> ID </b></td>
        <td><b> Protein </b></td>
        <td><b> Location </b> </td>
	<td><b>Select Gene <b><td>
	</tr>
__EOF

#########################################################################################
#				   Initial results page                          				 	
# Upon capturing the user's 2 inputs, namely search_type & user_input, these 2 strings	
# are passed as arguments through the subroutine called get_results which is in the 	  
# firstquery.pm module. The result page displays alternative gene identifiers.	       	
# Assuming the user may use chromosomal location as a gene id, the following script   	
# accounts for multiple genes by displaying the genes in a tabular format with the  	  
# option of choosing a specific gene.						                                       	
#########################################################################################




if (middle::queries::get_results($search_type, $user_input))   {

   my %results = middle::queries::get_results($search_type, $user_input);


   foreach my $accession_key (sort keys %results){
       if ($results{$accession_key} =~ /ID:(.+)PROTEIN:(.+)LOCATION:(.+)/)  {
	  print   "<tr><td> $accession_key </td><td>$1</td><td>$2</td><td>$3</td><td><input type='radio' name='specific_gene' value='$accession_key'/></td> </tr>";
      }
   }

}

else   {


    print "<p> Your search did not find any result. </p>";

}


print <<__EOF;
</table>
</div>
<br />
<br />
<p> Please select a gene and submit to learn more. </p>
<input type='submit' value='SUBMIT' />
</form>
</body>
</html>
__EOF
