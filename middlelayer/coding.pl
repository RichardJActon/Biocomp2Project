

use strict;
use warnings;



use DBI;

my $dbname = "ar001";
my $dbhost = "hope";
my $dbsource = "dbi:mysql:database=$dbname;host=$dbhost";
my $username = "ar001";
my $password = "9v15f7%xs";



my $dbh = DBI->connect($dbsource, $username, $password);

  
my $sql = "SELECT Genbank_Accession 
           FROM Loci";



my $sth = $dbh->prepare($sql);

my @array;

if($sth && $sth->execute)   {
        
   while(my $accession = $sth->fetchrow_array)   {
     push @array, $accession;
   }
}


my %cds;


foreach my $value (@array)  {



   my $sql2 = "SELECT DNA_seq
               FROM Loci 
               WHERE Genbank_Accession = '$value'";

   my %hash;
   my $seq = "";
   if($dbh)  {

     $seq = $dbh->selectrow_array($sql2);
   }


if (defined $seq)   {



   my $sql3 = "SELECT StartPosition, EndPosition
               FROM Exons
               WHERE Genbank_Accession = '$value'";
     
   
   my $coding = "";

   my $sth = $dbh->prepare($sql3);
   if($sth && $sth->execute)   {
        
      while(my ($start, $end) = $sth->fetchrow_array)   {
      
         my $len = ($end - $start) + 1;
        
         $coding .= substr($seq, $start, $len);
        
      }

         $cds{$value} = $coding;  
   
   }

}


     
}



# Printing them ou t to test it:

foreach my $key (keys %cds)   {
   print "$key = $cds{$key}";
}
