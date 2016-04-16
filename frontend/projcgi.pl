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
p	{color: black}
tr:hover {background-color: #3366CC}
tr 	{background-color: #708090 }
table, th, td {
   border: 2px solid black;
	border-collapse: collapse;
}

-->
</head>	
</style>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="http://www.w3schools.com/lib/w3.css">
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css">
<body class="w3-container">
<p align ='center'>
<a href="http://student.cryst.bbk.ac.uk/~ad002/projhome.html">
<span title="Home page"><img src ='http://student.cryst.bbk.ac.uk/~ad002/ch17logo2.png' width='50%' height='9%'alt='Explore Chromosome 17' /></span>
<i class="fa fa-spinner w3-spin" style="font-size:64px" style="color:blue"></i>
</a>
</p>
<body>
<form method="post" action="http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/ad002/projcgi2.pl">
<br />
<div class="w3-container w3-indigo w3-bottombar w3-border-dark-grey w3-border   w3-le" style="width:100%">
<h1> Search Results: </h1>
<p>Please select a gene and enter.</p>

</div>
<br />

<br />
<div style="overflow-x:auto;">

<table class="w3-table w3-bordered w3-border w3-card-4">
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
</div>

<br />
<br />
<div align="center">
<div class="w3-container w3-bottombar w3-border-black w3-border w3-hover-shadow  w3-center" style="width:20%" >
<p> Please select a gene and submit to learn more. </p>
<p align="center">
<input type='submit' value='SUBMIT'/>
</p>
</div>
</div>
</form>
</body>
</html>
__EOF
