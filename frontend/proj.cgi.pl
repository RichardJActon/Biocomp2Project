#!/usr/bin/perl
use CGI;
use strict;
my $cgi = new CGI;
print $cgi->header();

print <<__EOF;

>>Insert list of genes and their respective Gene Identifiers, Protein product names and Genbank accession


__EOF

