#!/usr/bin/perl
use strict;
########################### CGI ############################
use CGI;
use middle::firstquery;
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

#This CGI script uses the firstquery module and displays what is returned from
#the module in a results page.


#The following are the 2 strings captured from the user

#This is the type of string chosen by the user
my $Search_type = $cgi->param('Search_type');

#This is the actual string inputed by the user
my $User_input = $cgi->param('User_input');
	 


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
<form method="post" action="http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/ad002/projcgi2.pl">
<br />
<br />
<table border ="1">
	<tr>
	<td><b>Accessions</b></td>
	<td><b>Gene ID Product Location</b></td>
	<td><b>Select Gene<b><td>
	</tr>

__EOF

#This line calls on a function in the firstquery.pm module called the get_results
# subroutine which processes the 2 inputs of the user.

my %results = get_results($Search_type, $User_input);



foreach my $Accession_key (sort keys %results){
	print "<tr>
		<td>$Accession_key </td>
		<td> $results{$Accession_key} </td>
		<td><input type='radio' name='Specific_gene' value='$Accession_key'/></td>
		</tr>";

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




