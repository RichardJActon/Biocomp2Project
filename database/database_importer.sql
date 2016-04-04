-- import "|" separated file into database
-- 
LOAD DATA LOCAL INFILE 'loci.txt' INTO TABLE Loci
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(Genbank_Accession,Locus_GI,DNA_seq,Product_Name,CDS_untranslated,Reading_frame);
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
-- ALTER TABLE Loci INDEX(Genbank_Accession,Locus_GI,Product_Name);
-- ALTER TABLE Chromosome_Locations INDEX(Genbank_Accession,Location_Name);
-- ALTER TABLE Exons INDEX(Genbank_Accession,Exon_ID);

-- NB use "mysql --local-infile -u..." when running this script 
-- on newer versions of SQL which do not like the LOCAL comand