-- 
DROP DATABASE IF EXISTS Chromosome17;
CREATE DATABASE Chromosome17;
USE Chromosome17;
-- cmd line: mysql -u RichardActon -p"314159" Chromosome17 ##  mysql -u RichardActon -p"314159" < Chromosome17.sql

CREATE TABLE Chromosome_Locations
(	Chromosome_Location_ID	SMALLINT 	NOT NULL AUTO_INCREMENT,
	Location_Name			TEXT		NOT NULL,
	PRIMARY KEY (Chromosome_Location_ID)
)ENGINE = INNODB;

CREATE TABLE Loci
(	Genbank_Accession		VARCHAR(15)	DEFAULT NULL,
	Locus_GI				INT			NOT NULL,
	DNA_seq					LONGTEXT	NOT NULL,
	Product_Name			TEXT		NOT NULL,
	CDS_translated 			TEXT		NOT NULL,
	Chromosome_Location_ID	SMALLINT	DEFAULT NULL,
	CDS_untranslated		TEXT		DEFAULT NULL,
	PRIMARY KEY (Genbank_Accession)-- ,
)ENGINE = INNODB;

CREATE TABLE Exons
(	Genbank_Accession	VARCHAR(15)	DEFAULT NULL,
	StartPosition		SMALLINT	NOT NULL,
	EndPosition			SMALLINT	NOT NULL,
	Exon_ID				SMALLINT	NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (Exon_ID)-- ,
)ENGINE = INNODB;  
 -- #############################
 -- #### NOT NULLS? foreign key problems>?

ALTER TABLE Exons ADD CONSTRAINT exon_loci_Accession
FOREIGN KEY (Genbank_Accession) REFERENCES Loci (Genbank_Accession) 
ON UPDATE CASCADE ON DELETE CASCADE;
-- 
ALTER TABLE Loci ADD CONSTRAINT loci_chromLoc_ChromLocID
FOREIGN KEY (Chromosome_Location_ID) REFERENCES Chromosome_Locations (Chromosome_Location_ID) 
ON UPDATE CASCADE ON DELETE CASCADE;


-- ##load - > index
-- need auto increments on chrom id and exon id work out how these are dome
-- are there still mul keys - if so why?
