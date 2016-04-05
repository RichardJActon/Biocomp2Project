
use strict;
use warnings;
use DBI;

my $fname = $ARGV[0];


open(OUTFILE, ">$fname")
     or die "Can't open file $fname\n";

my $dbname = "ar001";
my $dbhost = "hope";
my $dbsource = "dbi:mysql:database=$dbname;host=$dbhost";
my $username = "ar001";
my $password = "9v15f7%xs";



my $dbh = DBI->connect($dbsource, $username, $password);


#### Extracting All Accessions ####
  
my $sql = "SELECT Genbank_Accession 
           FROM Loci";



my $sth = $dbh->prepare($sql);

my @array;

if($sth && $sth->execute)   {
        
   while(my $accession = $sth->fetchrow_array)   {
     push @array, $accession;
   }
}





#### Now I use each accession to retrieve the data necessary to build      ####
#### the coding sequence for each entry; I save each coding sequence       ####
#### in  an hash where keys are accessions and values are coding sequences ####

my %cds;


foreach my $value (@array)  {



   my $sql2 = "SELECT DNA_seq,
               Reading_Frame
               FROM Loci 
               WHERE Genbank_Accession = '$value'";

  
   my $seq = "";
   my $read = "";

   if($dbh)  {

     ($seq, $read) = $dbh->selectrow_array($sql2);
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
        
               $coding .= substr($seq, ($start- 1), $len);
        
         }
 
         my $length = length($coding);
         $coding = substr($coding, ($read - 1), $length - ($read - 1));
         $cds{$value} = $coding;
 
   
      }

   }

     
}

my $all_coding = "";


# Printing them ou t to test it:

foreach my $key (keys %cds)   {

   $all_coding .= $cds{$key};

}

print OUTFILE $all_coding . "\n";





