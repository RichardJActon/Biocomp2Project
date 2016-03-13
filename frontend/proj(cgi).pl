#!/usr/bin/perl
use strict;
############################################################
use CGI;
use middle::firstquery;
my $cgi = new CGI;
print $cgi->header();

############################################################
use DBI;

my $dbname = "Chromosome17";
my $dbhost = "hope";
my $dbsource = "dbi:mysql:database=$dbname;host=$dbhost";

#Database username and password is optional
my $username = "database-user";
my $password = "database-password";

$dbh = DBI->connect($dbsource, $username, $password);
#############################################################

#This section uses the firstquery module and displays what is returned from
#the module in a results html page.


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
</html>

__EOF

#This line calls on a function in the firstquery.pm module called the get_accessions 
# subroutine which processes the 2 inputs of the user.

my @Accessions = get_accession($Search_type, $User_input);

#This line calls on a second subroutine from the firstquery.pm module to repackage the data 
#retreived from the database in a suitable format for unpacking and displaying.

my %OrderedAccessions = subroutine2(@Accessions);


foreach my $key (sort keys %OrderedAccessions){
	print "<p>$key = $OrderedAccessions{$key}</p>";
}




