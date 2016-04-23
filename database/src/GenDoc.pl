#!/usr/bin/perl
use warnings;
use strict;
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

my @scripts;
my @modules;
my @pods;

while (defined(my $file = readdir(SRC))) 
{
	if ($file =~ /.*\.pl|.*\.pm|.*\.pod/) 
	{
		if ($file =~ /.*\.pl/) 
		{
			my $filename = $file;
			$filename =~ s/\.pl|\.pm|\.t$|\.pod//;
			push @scripts, $filename;
		}
		elsif($file =~ /.*\.pm/) 
		{
			my $filename = $file;
			$filename =~ s/\.pl|\.pm|\.t$|\.pod//;
			push @modules, $filename;
		}
		# elsif($file =~ /.*\.pod/) 
		# {
		# 	my $filename = $file;
		# 	$filename =~ s/\.pl|\.pm|\.t$|\.pod//;
		# 	push @pods, $filename;
		# }
		push @srcfiles, $file;
		my $filename = $file;
		$filename =~ s/\.pl|\.pm|\.t$|\.pod//;
		push @srcfilenames, $filename;
		#print "$file\n";
	}
}

for (my $i = 0; $i < scalar @srcfiles; $i++) {
	pod2html("--header","--recurse","--podroot=../doc","--htmldir=../doc","--infile=$srcfiles[$i]","--outfile=$DOC/$srcfilenames[$i].html","--css=DocStylesheet.css");
}


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
	pod2html("--header","--recurse","--podroot=../doc","--htmldir=../doc","--infile=$DOC/$docfiles[$i]","--outfile=$DOC/$docfilenames[$i].html","--css=DocStylesheet.css");
}


######################
my $indexpod = "../doc/index.pod";
open(INDEX, ">$indexpod") or die "could not open $indexpod\n";

print INDEX <<__EOF

=pod

=head1 Documentation for Chromosome 17 Database

B<Author: Richard J. Acton> 

B<Date: 21-03-2016>

B<Biocomputing 2 Project>

git repository: L<https://github.com/RichardJActon/Biocomp2Project>

Website URL: L<http://student.cryst.bbk.ac.uk/~ad002/projhome.html>

=head2 Commentary

=begin html

<p><a href="./Commentary.html">Commentary</a></p>

=end html

=head2 Documentation

=head3 Scripts
__EOF
;
for (my $i = 0; $i < scalar @scripts; $i++) 
{
	print INDEX <<__EOF 

=begin html

<p><a href="./$scripts[$i].html">$scripts[$i]</a></p>

=end html

__EOF
;
}

print INDEX <<__EOF 

=head3 Modules

__EOF
;

for (my $i = 0; $i < scalar @modules; $i++) 
{
print INDEX <<__EOF 

=begin html

<p><a href="./$modules[$i].html">$modules[$i]</a></p>

=end html

__EOF
;
}


print INDEX <<__EOF 

=head3 PODs - Files not documented inline

__EOF
;

for (my $i = 0; $i < scalar @docfilenames; $i++) 
{
print INDEX <<__EOF 

=begin html

<p><a href="./$docfilenames[$i].html">$docfilenames[$i]</a></p>

=end html

__EOF
;
}

print INDEX <<__EOF 

=cut

__EOF
;
#############
close(INDEX) or die "could not close $indexpod\n";

#######################


my $index = "../doc/index.pod";
pod2html("--header","--podroot=../doc","--htmldir=../doc","--infile=$index","--outfile=../doc/index.html","--css=DocStylesheet.css");


##############

closedir(SRC) or die "unable to close $SRC\n";
closedir(DOC) or die "unable to close $DOC\n";