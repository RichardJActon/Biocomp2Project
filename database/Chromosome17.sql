-- 
DROP DATABASE Chromosome17;
CREATE DATABASE Chromosome17;
USE Chromosome17;
-- 
CREATE TABLE Chromosome_Locations
(	Chromosome_Location_ID	SMALLINT 	DEFAULT NULL,
	Location_Name			TEXT		NOT NULL,
	PRIMARY KEY (Chromosome_Location_ID)
);

CREATE TABLE Loci
(	Genebank_Accession		VARCHAR(8)	DEFAULT NULL,
	GI_number				SMALLINT	NOT NULL,
	Chromosome_Location_ID	SMALLINT	DEFAULT NULL,
	DNA_sequence			LONGTEXT	NOT NULL,
	Product					TEXT		NOT NULL,
	CDS_translated 			TEXT		NOT NULL,
	CDS_untranslated		TEXT		NOT NULL,
	PRIMARY KEY (Genebank_Accession)-- ,
--  	FOREIGN KEY (Chromosome_Location_ID) REFERENCES Chromosome_Locations(Chromosome_Location_ID)
);

CREATE TABLE Exons
(	Exon_ID				SMALLINT	DEFAULT NULL,
	Genebank_Accession	VARCHAR(8)	DEFAULT NULL,
	StartPosition		SMALLINT	NOT NULL,
	EndPosition			SMALLINT	NOT NULL,
	PRIMARY KEY (Exon_ID)-- ,
-- 	FOREIGN KEY (Genebank_Accession) REFERENCES Loci(Genebank_Accession)
);