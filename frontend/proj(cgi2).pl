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

$dbh = DBI->connect($dbsource17, $username, $password);
#############################################################

#This script is called on when a radio button is clicked 
#on and submitted in the results page displayed through 
#the first cgi script(proj(cgi).pl) 

my $Specific_gene = $cgi->parama('Specific_gene');

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
<title>Details of Gene: $Specific_gene</title>
</head>	
</style>

__EOF


