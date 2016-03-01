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
for (my $i = 0; $i < scalar @loci; $i++) 
{
	my $subline = "";
	for (my $j = 0; $j < scalar @lines; $j++) {
		if ($lines[$j] =~ /^LOCUS\s{7}${loci[$i]}/) 
		{	
			until ($lines[$j] =~ /^ORIGIN/) 
			{
				$j++;
				if ($lines[$j] =~/\/\// )
				{				
					$subline = $lines[$j];
					print "$lines[$j]\n\n";
					$subline =~ s/[0-9]|\n|\s//g;
					$seq = $seq . $subline;
					$j++;
				}
				
			}
			push @seqs, $seq;
			#print "$seq\n";
			$seq = "";
		}
	}
}
print "@seqs[0]\n\n";
print "@seqs[1]\n\n";
print "@seqs[2]\n\n";
print "@seqs[20]\n\n";
print "@seqs[20]\n\n";
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


