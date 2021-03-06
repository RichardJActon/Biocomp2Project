﻿/*
=pod

=head1 Database Importer

=begin html

<p><a href="./index.html">home</a></p>

=end html

=head2 Synopsis

=over

Takes the data output by the genbank file parser into 3 "|" separated files and imports each into
their corresponding tables in the database. This script also builds the index for the database 
following the import of the data.

=back

=head2 Arguments

=over

=item *
File named "loci.txt" containing columns: Genbank_Accession, Locus_GI, DNA_seq, Product_Name,
 CDS_translated, Reading_frame separated by "|" with each row on a new line "\n".

=item *
File named "chromloc.txt" containing columns: Genbank_Accession, Location_Name
 separated by "|" with each row on a new line "\n".

=item *
File named "exons.txt" containing columns: Genbank_Accession, StartPosition, EndPosition, Exon_ID
 separated by "|" with each row on a new line "\n".

=back

=head2 Returns

=over

=item *
The data is loaded into the database.

=back

=cut
*/
-- import "|" separated file into database
-- 
LOAD DATA LOCAL INFILE 'loci.txt' INTO TABLE Loci
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(Genbank_Accession,Locus_GI,DNA_seq,Product_Name,CDS_translated,Reading_frame);
-- 
LOAD DATA LOCAL INFILE 'chromloc.txt' INTO TABLE Chromosome_Locations
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(Genbank_Accession,Location_Name);
-- 
LOAD DATA LOCAL INFILE 'exons.txt' INTO TABLE Exons
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(Genbank_Accession, StartPosition,EndPosition,Exon_ID);

-- indices
ALTER TABLE Loci INDEX(Genbank_Accession, Locus_GI, Reading_frame);
ALTER TABLE Chromosome_Locations INDEX(Genbank_Accession);
ALTER TABLE Exons INDEX(Genbank_Accession,Exon_ID);