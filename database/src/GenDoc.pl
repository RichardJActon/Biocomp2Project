#!/usr/bin/perl
use warnings;
use strict;
use INDEX_GEN;
use Pod::Html;

#use Pod::Tree;
#use HTML::Stream;
##
##use File::Find::Rule;
## ^ find subdirs?

#pod2html
my $in_dir = "../src";
my $out_dir = "../doc";
opendir(IN_DIR, $in_dir) or die "unable to open $in_dir\n";
opendir(OUT_DIR, $out_dir) or die "unable to open $out_dir\n";

my @podfiles;

while (defined(my $file = readdir(IN_DIR))) {
	if ($file =~ /.*\.pl|.*\.pm|.*\.t$|.*\.pod/) {
		push @podfiles, $file;
		#print "$file\n";
	}
}

for (my $i = 0; $i < scalar @podfiles; $i++) {
	pod2html("--podroot=../doc","--htmldir=../doc","--infile=$podfiles[$i]","--outfile=$out_dir/$podfiles[$i].html","--css=DocStylesheet.css");
}

######################
INDEX_GEN::INDEXGEN(); 
my $index = "../doc/index.pod";
pod2html("--podroot=../doc","--htmldir=../doc","--infile=$index","--outfile=../doc/index.html","--css=DocStylesheet.css");


########

#pod2html("podroot=/","podpath=../src","--htmldir=../doc","--recurse","--css=DocStylesheet.css");#,"--infile=","--outfile=");
# #"$ARGV[0]",
##
# my $source = Pod::Tree -> new("../src");
# my $dest = HTML::Stream -> new("../doc");

#pods2html [[--base ../src][--css DocStylesheet.css]];
#pods2html("--base ../src","--css DocStylesheet.css");

##############

closedir(IN_DIR) or die "unable to close $in_dir\n";
closedir(OUT_DIR) or die "unable to close $out_dir\n";