#!/usr/bin/perl
use CGI;
use strict;
use middle::firstquery;
my $cgi = new CGI;
print $cgi->header();

#This section uses the firstquery module and displays what is returned from the module in a results html page.


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
body { background: #;
       color: ; }
h1   { color: ;
	font-family: calibri; 
	font-size: 100%;  }
-->
<title>Search result(s)</title>
</head>	

</style>
</html>

__EOF

#This line calls on a function in the firstquery.pm module called the get_accessions subroutine
#which processes the 2 inputs of the user.

my @Accessions = get_accession($Search_type, $User_input)


my %OrderedAccessions = subroutine2(@Accessions);


foreach my $key (keys %OrderedAccessions){
	print "<p>$key = $OrderedAccessions{$key}</p>";
}




