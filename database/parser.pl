#!/usr/bin/perl
use strict;
use warnings;
#use DBsubroutines;
use DBI;
#
#test script

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
				$j++;
				$subline = $lines[$j];
				if ($subline =~/^\/\//) 
				{
					$subline = "";
				}
				$subline =~ s/[0-9]|\n|\s//g;
				#print "$subline\n";
				$seq .= $subline;
				$subline = "";
			}
			push @seqs, $seq;
			#print "$seq\n";
			$seq = "";
		}
	}
}

for (my $i = 0; $i < scalar @seqs; $i++) {
	print "$seqs[$i]\n";
}
#print "$seqs[0]\n\n";

########################################################
# my %attributes;
# my $attribute = "";
# my $subline = "";
# 	for (my $i = 0; $i < scalar @loci; $i++) 
# 	{
# 		my $j = 0;
# 		print $lines[$j];
# 		until ($lines[$j] =~ /^LOCUS\s{7}$loci[$i]/) 
# 		{
# 			print $lines[$j];
# 			$j++;
# 			until ($lines[$j] =~ /^ORIGIN/)
# 			{
# 				print $lines[$j];
# 				$j++;
# 				$subline = $lines[$j];
# 				$subline =~ s/[0-9]|\n//g;
# 				$attribute = $attribute . $subline;
# 				if ($lines[$j] = /\/\//) 
# 				{
# 					last;
# 				}
# 			}
# 		}
# 	$attributes{$loci[$i]} = $attribute;
# 	$attribute = "";
# 	$subline = "";
#	}

#%seqs = DBsubroutines::EXTRACT_LOCUS_FEATURE(@loci,@lines);


# print %seqs;
# print %attributes;


