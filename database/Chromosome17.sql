-- 
DROP DATABASE IF EXISTS Chromosome17;
CREATE DATABASE Chromosome17;
USE Chromosome17;
-- cmd line: mysql -u RichardActon -p"314159" Chromosome17 ##  mysql -u RichardActon -p"314159" < Chromosome17.sql

CREATE TABLE Chromosome_Locations
(	Chromosome_Location_ID	SMALLINT 	DEFAULT NULL,
	Location_Name			TEXT		NOT NULL,
	PRIMARY KEY (Chromosome_Location_ID)
)ENGINE = INNODB;

CREATE TABLE Loci
(	Genebank_Accession		VARCHAR(8)	DEFAULT NULL,
	GI_number				SMALLINT	NOT NULL,
	Chromosome_Location_ID	SMALLINT	DEFAULT NULL,
	DNA_sequence			LONGTEXT	NOT NULL,
	Product					TEXT		NOT NULL,
	CDS_translated 			TEXT		NOT NULL,
	CDS_untranslated		TEXT		NOT NULL,
	PRIMARY KEY (Genebank_Accession)-- ,
)ENGINE = INNODB;

CREATE TABLE Exons
(	Exon_ID				SMALLINT	DEFAULT NULL,
	Genebank_Accession	VARCHAR(8)	DEFAULT NULL,
	StartPosition		SMALLINT	NOT NULL,
	EndPosition			SMALLINT	NOT NULL,
	PRIMARY KEY (Exon_ID)-- ,
)ENGINE = INNODB;  
 -- #############################
 -- #### NOT NULLS? foreign key problems>?

ALTER TABLE Exons ADD CONSTRAINT exon_loci_Accession
FOREIGN KEY (Genebank_Accession) REFERENCES Loci (Genebank_Accession) 
ON UPDATE CASCADE ON DELETE CASCADE;
-- 
ALTER TABLE Loci ADD CONSTRAINT loci_chromLoc_ChromLocID
FOREIGN KEY (Chromosome_Location_ID) REFERENCES Chromosome_Locations (Chromosome_Location_ID) 
ON UPDATE CASCADE ON DELETE CASCADE;


-- ##load - > index
-- need auto increments on chrom id and exon id work out how these are dome