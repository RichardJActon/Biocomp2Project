/*
=pod

=head1 Database Importer



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
-- indices?
