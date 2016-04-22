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
my $SRC = "../src";
my $DOC = "../doc";
opendir(SRC, $SRC) or die "unable to open $SRC\n";
opendir(DOC, $DOC) or die "unable to open $DOC\n";

my @srcfiles;
my @srcfilenames;

while (defined(my $file = readdir(SRC))) {
	if ($file =~ /.*\.pl|.*\.pm|.*\.t$|.*\.pod/) {
		push @srcfiles, $file;
		my $filename = $file;
		$filename =~ s/\.pl|\.pm|\.t$|\.pod//;
		push @srcfilenames, $filename;
		#print "$file\n";
	}
}

for (my $i = 0; $i < scalar @srcfiles; $i++) {
	pod2html("--podroot=../doc","--htmldir=../doc","--infile=$srcfiles[$i]","--outfile=$DOC/$srcfilenames[$i].html","--css=DocStylesheet.css");
}

######################
INDEX_GEN::INDEXGEN(); 

my @docfiles;
my @docfilenames;


while (defined(my $file = readdir(DOC))) {
	if ($file =~ /.*\.pod/) {
		push @docfiles, $file;
		my $filename = $file;
		$filename =~ s/\.pod//;
		push @docfilenames, $filename;
		#print "$file\n";
	}
}

for (my $i = 0; $i < scalar @docfiles; $i++) {
	pod2html("--podroot=../doc","--htmldir=../doc","--infile=$DOC/$docfiles[$i]","--outfile=$DOC/$docfilenames[$i].html","--css=DocStylesheet.css");
}



# my $index = "../doc/index.pod";
# pod2html("--podroot=../doc","--htmldir=../doc","--infile=$index","--outfile=../doc/index.html","--css=DocStylesheet.css");


########

#pod2html("podroot=/","podpath=../src","--htmldir=../doc","--recurse","--css=DocStylesheet.css");#,"--infile=","--outfile=");
# #"$ARGV[0]",
##
# my $source = Pod::Tree -> new("../src");
# my $dest = HTML::Stream -> new("../doc");

#pods2html [[--base ../src][--css DocStylesheet.css]];
#pods2html("--base ../src","--css DocStylesheet.css");

##############

closedir(SRC) or die "unable to close $SRC\n";
closedir(DOC) or die "unable to close $DOC\n";