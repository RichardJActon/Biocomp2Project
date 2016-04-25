#!/usr/bin/perl
use warnings;
use strict;
use Pod::Html;

# GenDoc.pl is a script to automatically generate an HTML version of the documentation
# for this software. The perl scripts and modules in this software contain in-line documentation
# written in POD - Plain old documentation. this script processes all of the .pl, .pm, .pod and .t files
# in the SCR directory and its t subdirectory and the DOC directory using the Pod2HTML package. 
# this script also produces an index page with links to all of the documentation file that is generates.

# Author: Richard J. Acton
# Date: 04-2016

#pod2html

# open directories

my $SRC = "../src";
my $T = "../src/t";
my $DOC = "../doc";
opendir(SRC, $SRC) or die "unable to open $SRC\n";
opendir(T, $T) or die "unable to open $T\n";
opendir(DOC, $DOC) or die "unable to open $DOC\n";

# extract file names of perl scripts, modules and pod documents

my @srcfiles;
my @srcfilenames;

my @scripts;
my @modules;
my @sql;

while (defined(my $file = readdir(SRC))) 
{
	if ($file =~ /.*\.pl|.*\.pm|.*\.pod|.*\.sql/) 
	{
		if ($file =~ /.*\.pl/) 
		{
			my $filename = $file;
			$filename =~ s/\.pl//;
			push @scripts, $filename;
		}
		elsif($file =~ /.*\.pm/) 
		{
			my $filename = $file;
			$filename =~ s/\.pm//;
			push @modules, $filename;
		}
		elsif($file =~ /.*\.sql/) 
		{
			my $filename = $file;
			$filename =~ s/\.sql//;
			push @sql, $filename;
		}
		push @srcfiles, $file;
		my $filename = $file;
		$filename =~ s/\.pl|\.pm|\.t$|\.pod|\.sql//;
		push @srcfilenames, $filename;
	}
}

for (my $i = 0; $i < scalar @srcfiles; $i++) 
{
	pod2html("--recurse","--podroot=../doc","--htmldir=../doc","--infile=$srcfiles[$i]","--outfile=$DOC/$srcfilenames[$i].html","--css=DocStylesheet.css");
}
#####################

# extract names of .t files from test directory

my @tfiles;
my @tfilenames;

while (defined(my $file = readdir(T))) 
{
	if ($file =~ /.*\.t$/) 
	{
		push @tfiles, $file;
		my $filename = $file;
		$filename =~ s/\.t$//;
		push @tfilenames, $filename;
	}
}

for (my $i = 0; $i < scalar @tfiles; $i++) 
{
	pod2html("--recurse","--podroot=../doc","--htmldir=../doc","--infile=$T/$tfiles[$i]","--outfile=$DOC/$tfilenames[$i].html","--css=DocStylesheet.css");
}

#####################

# extract names of .pod files from the documentation directory
my @docfiles;
my @docfilenames;


while (defined(my $file = readdir(DOC))) 
{
	if ($file =~ /.*\.pod/) {
		push @docfiles, $file;
		my $filename = $file;
		$filename =~ s/\.pod//;
		push @docfilenames, $filename;
	}
}

for (my $i = 0; $i < scalar @docfiles; $i++) 
{
	pod2html("--recurse","--podroot=../doc","--htmldir=../doc","--infile=$DOC/$docfiles[$i]","--outfile=$DOC/$docfilenames[$i].html","--css=DocStylesheet.css");
}


######################

# write the index page for the documentation

my $indexpod = "../doc/index.pod";
open(INDEX, ">$indexpod") or die "could not open $indexpod\n";

#######################
print INDEX <<__EOF

=pod

=head1 Documentation for Chromosome 17 Database

B<Author: Richard J. Acton> 

B<Date: 21-03-2016>

B<Biocomputing 2 Project>

git repository: L<https://github.com/RichardJActon/Biocomp2Project>

Website URL: L<http://student.cryst.bbk.ac.uk/~ad002/projhome.html>

=head2 Overview of how to use this program:

=over

=item 1
Run the Parser.pl script with your genbank file as an argument.

=item 2
Run the Chromosome17.sql file on your SQL server to create the database.

=item 3
Run the database_importer.sql script from a directiry containing the file output by the Parser to import
 the imformation into the database.

=back

=head2 Commentary

=begin html

<p><a href="./Commentary.html">Commentary</a></p>

=end html

=head2 Documentation

=head3 Scripts
__EOF
;
#######################
for (my $i = 0; $i < scalar @scripts; $i++) 
{
	print INDEX <<__EOF 

=begin html

<p><a href="./$scripts[$i].html">$scripts[$i]</a></p>

=end html

__EOF
;
}
#######################
print INDEX <<__EOF 

=head3 Modules

__EOF
;
#######################
for (my $i = 0; $i < scalar @modules; $i++) 
{
print INDEX <<__EOF 

=begin html

<p><a href="./$modules[$i].html">$modules[$i]</a></p>

=end html

__EOF
;
}
#######################
print INDEX <<__EOF 

=head3 PODs - Files not documented inline

__EOF
;
#######################
for (my $i = 0; $i < scalar @docfilenames; $i++) 
{
print INDEX <<__EOF 

=begin html

<p><a href="./$docfilenames[$i].html">$docfilenames[$i]</a></p>

=end html

__EOF
;
}
#######################
print INDEX <<__EOF 

=head3 Test Scripts

__EOF
;
#######################
for (my $i = 0; $i < scalar @tfilenames; $i++) 
{
print INDEX <<__EOF 

=begin html

<p><a href="./$tfilenames[$i].html">$tfilenames[$i]</a></p>

=end html

__EOF
;
}
#######################
print INDEX <<__EOF 

=head3 SQL Scripts

__EOF
;
#######################
for (my $i = 0; $i < scalar @sql; $i++) 
{
print INDEX <<__EOF 

=begin html

<p><a href="./$sql[$i].html">$sql[$i]</a></p>

=end html

__EOF
;
}
#######################

print INDEX <<__EOF 

=cut

__EOF
;
#############
close(INDEX) or die "could not close $indexpod\n";

#######################

# generate the HTML version of the index page

my $index = "../doc/index.pod";
pod2html("--podroot=../doc","--htmldir=../doc","--infile=$index","--outfile=../doc/index.html","--css=DocStylesheet.css");

##############

# close directories

closedir(SRC) or die "unable to close $SRC\n";
closedir(T) or die "unable to close $T\n";
closedir(DOC) or die "unable to close $DOC\n";