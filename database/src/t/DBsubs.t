#!/usr/bin/perl
use warnings;
use strict;
use lib '..';
use DBsubs;
use Test::More tests => 20;
### DBsubs.t
=pod

=head2 DBsubs tests script

=cut
####################################################################################################
##### 										EXISTS function									   #####
####################################################################################################
=pod

=head3 Tests for the EXISTS function

=over

=item 1 
EXISTS returns 1 when file exists.

=item 2
EXISTS returns 0 when variable empty.

=item 3
EXISTS returns 0 when non-existent file name used.

=back

=cut

## 
my $file1 = "TTF.txt";
my $result1 = DBsubs::EXISTS($file1);
my $expected1 = 1;
is ($result1, $expected1, "EXISTS returns 1 when file exists");

##
my $file2 = "";
my $result2 = DBsubs::EXISTS($file2);
my $expected2 = 0;
is ($result2, $expected2, "EXISTS returns 0 when variable empty");

##
my $file3 = "XXX.txt";
my $result3 = DBsubs::EXISTS($file3);
my $expected3 = 0;
is ($result3, $expected3, "EXISTS returns 0 when non-existent file name used");

####################################################################################################
#####									IS_TEXT												   #####
####################################################################################################
=pod

=head3 tests for the IS_TEXT function

=over

=item 1


=back

=cut

## 
my $file4 = "TTF.txt";
my $result4 = DBsubs::IS_TEXT($file1);
my $expected4 = 1;
is ($result4, $expected4, "IS_TEXT returns 1 when file is text");

##
my $file5 = "";
my $result5 = DBsubs::IS_TEXT($file5);
my $expected5 = 0;
is ($result5, $expected5, "IS_TEXT returns 0 when variable empty");

##
my $file6 = "XXX.txt";
my $result6 = DBsubs::IS_TEXT($file6);
my $expected6 = 0;
is ($result6, $expected6, "IS_TEXT returns 0 when non-existent file name used");

##
my $file7 = "Non-text_file.xxx"; ###  find a non text file
my $result7 = DBsubs::IS_TEXT($file7);
my $expected7 = 0;
is ($result7, $expected7, "IS_TEXT returns 0 when non-text file name used");

####################################################################################################
#####									IS_READABLE											   #####
####################################################################################################
=pod

=head3 tests for the IS_READABLE function

=over

=back

=cut

## 
my $file8 = "TTF.txt";
my $result8 = DBsubs::IS_READABLE($file8);
my $expected8 = 1;
is ($result8, $expected8, "IS_READABLE returns 1 when file is readable");

##
my $file9 = "";
my $result9 = DBsubs::IS_READABLE($file9);
my $expected9 = 0;
is ($result5, $expected9, "IS_READABLE returns 0 when variable empty");

##
my $file10 = "NotReadable.txt";
my $result10 = DBsubs::IS_READABLE($file10);
my $expected10 = 0;
is ($result10, $expected10, "IS_READABLE returns 0 when file is not readable");
####################################################################################################
#####								FILE_LINES_TO_ARRAY										   #####
####################################################################################################
=pod

=head3 tests for the FILE_LINES_TO_ARRAY function

=over

=back

=cut

## 
my $file11 = "TTF.txt";
my @array = DBsubs::FILE_LINES_TO_ARRAY($file11);
ok(@array,"FILE_LINES_TO_ARRAY Sucessfully returns an array");

# my $expected8 = 1;
# is ($result8, $expected8, "IS_READABLE returns 1 when file is readable");

####################################################################################################
#####								HASH_LOCI_CONTENTS										   #####
####################################################################################################
=pod

=head3 tests for the HASH_LOCI_CONTENTS function

=over

=back

=cut

## 
my @array2 = ("xa\n","a\n","y\n","xb\n","b\n","y\n","xc\n","c\n","y\n");
#print @array2;
my $regex1 = qr/x(\w*)/;
my $regex2 = qr/y\n/;
my %hash = DBsubs::HASH_LOCI_CONTENTS(\@array2,$regex1,$regex2);
ok(%hash,"HASH_LOCI_CONTENTS Sucessfully returns an hash");
ok($hash{a} eq "xa\na\ny\n", "HASH_LOCI_CONTENTS correct contents for first value" );
ok($hash{b} eq "xb\nb\ny\n", "HASH_LOCI_CONTENTS correct contents for second value" );
ok($hash{c} eq "xc\nc\ny\n", "HASH_LOCI_CONTENTS correct contents for third value" );
# my $expected8 = 1;
# is ($result8, $expected8, "IS_READABLE returns 1 when file is readable");


# test for normal function need to address error handeling of this function
# what happens when unexpected input is given how can it be detected and 
# produce and appropriate error behaviour?
ok(scalar keys %hash == 3, "HASH_LOCI_CONTENTS returns a hash with 3 keys");
ok(scalar values %hash == 3, "HASH_LOCI_CONTENTS returns a hash with 3 values");
#
####################################################################################################
#####  									EXTRACT_LOCUS_FEATURE			 		       		   #####
####################################################################################################
=pod

=head3 tests for the EXTRACT_LOCUS_FEATURE function

=over

=back

=cut

## 
my %inHash;
$inHash{1} = "_a_";
$inHash{2} = "b";
$inHash{3} = "";

my $featureRegex = qr/_([a])_/;

my %outHash = DBsubs::EXTRACT_LOCUS_FEATURE(\%inHash,$featureRegex);

ok($outHash{1} eq "a","EXTRACT_LOCUS_FEATURE returns value of match on match match");
ok($outHash{2} eq "Parsing error feature not defined","EXTRACT_LOCUS_FEATURE returns error on not match");
ok($outHash{3} eq "Parsing error feature not defined", "EXTRACT_LOCUS_FEATURE returns error on empty value");
