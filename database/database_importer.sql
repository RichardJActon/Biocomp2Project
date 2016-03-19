-- import "|" separated file into database
LOAD DATA LOCAL INFILE 'test_3.txt' INTO TABLE Loci
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(Genbank_Accession,Locus_GI,DNA_seq,Product_Name,CDS_translated)