#!/usr/bin/perl
use warnings;
use strict;
use lib '..';
use DBsubs;
use Test::More tests => 1;


###  DBsubs.t

### Tests for EXISTS function
my $TTF = "TTF.txt";

my $result = DBsubs::EXISTS($TTF);
my $expected = 1;
is ($result, $expected, "1 when file exists");
