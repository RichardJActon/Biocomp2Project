#!/usr/bin/perl
use CGI;
use strict;


###### This is a script to find and highlight (in bold) enxymes restriction sites in a sequence. ####
### There are 3 if statements, one for each enzymme. ####
### each enzyme has a specific motif that can recognize in a sequence. ####
### In the interface the user will select the enzyme for which he wants###
### to look for restriction sites; this will be captured in the variable $type ####
### (In the interface we need radio buttons (or a dropdown) for the 3 enzymes, which the user can select). ####
### The script is simple: basically given a sequence ($val) the regex search for the enzyme motif in the sequence ####
### and if it finds it, it edits the motif by enclosing it in 2 bold tags; so when u print the sequence in html the bold tags ####
### print in bold whatever is inbetween. ####


### IMPORTANT: I did not take into account the fact the we only need to highlight the sites #####
#### in the 5 or 3 regions and not inbetween; I did not understand what that means ####
### from a biological point of view; I will ask soon, or you can let me know by email. ###


### This method can also be edited and can probably be used to display the full dna sequence with the exon highlighted ####



####IMPORTANT : if you want to try the script I created an html page which uses this cgi ####
#### http://student.cryst.bbk.ac.uk/~ng001/form2.html ####
### enter ur sequence, select the enxyme for which you want to look for restriction sites and press submit ###
## it works ###


my $cgi = new CGI;
my $val = $cgi->param('Sequence');
my $name = $cgi->param('Name');
my $type = $cgi->param('Search type');


print $cgi->header();
print <<__EOF;
<html>
<head>
   <title>Sequence Analysis Results</title>
</head>
<body>
<h1> Sequence  Analysis Results </h1>
__EOF
print "<p>Data submitted by: <b>$name</b></p>\n";
print "<h2> Your sequence restictrion sites for $type:</h2>\n";




if ($type eq "EcoRI")   {
   $val =~ s{gaattc}{<b>gaattc</b>}g;
}

elsif ($type eq "BamHI")   {
   $val =~ s{ggatcc}{<b>ggatcc</b>}g;
}

elsif ($type eq "BsuMI")   {
   $val =~ s{ctcgag}{<b>ctcgag</b>}g;
}

print "<p>$val</p>";

print "<p> Your searched for $type restriction sites.</p>\n";
print "<h3> <p>Thank you for using my application.</p><p>Gabriele Nocchi</p></h3>";
print "</body></html>\n";
