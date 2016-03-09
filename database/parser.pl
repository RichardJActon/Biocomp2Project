#!/usr/bin/perl
use strict;
use warnings;
#use DBsubroutines;
#use DBI;
#
#test script
########################################################
my @loci;
my $line;
my @lines;
my %seqs;
while ($line = <>) 
{
push @lines, $line;
	if ($line =~ /^LOCUS\s{7}(\w{8})/) 
	{
		push @loci, $1;
	}	
}
for (my $i = 0; $i < scalar @loci; $i++) 
{
	print "$loci[$i]\n";
}
print "\n";
########################################################
##
# for (my $i = 0; $i < scalar @lines; $i++) 
# {
# 	print "$lines[$i]\n";
# }
########################################################
my @seqs;
my $seq = "";
my $subline = "";
for (my $i = 0; $i < scalar @loci; $i++) 
{
	for (my $j = 0; $j < scalar @lines ; $j++) 
	{
		if ($lines[$j] =~ /^LOCUS\s{7}${loci[$i]}/) 
		{	
			while ($lines[$j] !~ /^ORIGIN/ and defined $lines[$j]) 
			{
				$j++;
			}
			while ($lines[$j] !~/^\/\// and defined $lines[$j])
			{				
				$subline = $lines[$j];
				$subline =~ s/[0-9]|\n|\s//g;
				$seq .= $subline;
				$subline = "";
				$j++;
			}
			$seq =~ s/^ORIGIN//g;
			$seq =~ s/^\/\///g;
			push @seqs, $seq;
			$seq = "";
		}
	}
}

for (my $i = 0; $i < scalar @seqs; $i++) {
	print "$seqs[$i]\n";
}

print "\n";

########################################################
# my @seqs;
# my $seq = "";
# my $subline = "";
# for (my $i = 0; $i < scalar @loci; $i++) 
# {
# 	for (my $j = 0; $j < scalar @lines ; $j++) 
# 	{
# 		if ($lines[$j] =~ /^LOCUS\s{7}${loci[$i]}/) 
# 		{	
# 			while ($lines[$j] !~ /^ORIGIN/ and defined $lines[$j]) 
# 			{
# 				$j++;
# 			}
# 			while ($lines[$j] !~/^\/\// and defined $lines[$j])
# 			{				
# 				$j++; ## problem for generalisablity to matches on same line
# 				$subline = $lines[$j];
# 				if ($subline =~/^\/\//) 
# 				{
# 					$subline = "";
# 				}
# 				$subline =~ s/[0-9]|\n|\s//g;
# 				$seq .= $subline;
# 				$subline = "";
# 			}
# 			push @seqs, $seq;
# 			$seq = "";
# 		}
# 	}
# }

# for (my $i = 0; $i < scalar @seqs; $i++) {
# 	print "$seqs[$i]\n";
# }
