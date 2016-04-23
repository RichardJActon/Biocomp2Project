-- 
/*
=pod

=head1 Database Creation Script for Chromosome17

=head2 synopsis



This version is for creating a database on a local machine. Changes had to be made to accommodate the limited permissions
available on the Birkbeck server, for example the entire database cannot be dropped on the Birkbeck server so each table
is dropped individually if they already exist in that version.

=head2 

=cut
*/
DROP DATABASE IF EXISTS Chromosome17;
CREATE DATABASE Chromosome17;
USE Chromosome17;
-- cmd line: mysql -u RichardActon -p"314159" Chromosome17 ##  mysql -u RichardActon -p"314159" < Chromosome17.sql

CREATE TABLE Chromosome_Locations
(	Genbank_Accession		VARCHAR(15)	DEFAULT NULL,
	Location_Name			TEXT		NOT NULL
)ENGINE = INNODB;

CREATE TABLE Loci
(	Genbank_Accession		VARCHAR(15)	DEFAULT NULL,
	Locus_GI				INT			NOT NULL,
	DNA_seq					LONGTEXT	NOT NULL,
	Product_Name			TEXT		NOT NULL,
	CDS_translated 			TEXT		NOT NULL,
	CDS_untranslated		TEXT		DEFAULT NULL,
	Reading_Frame			SMALLINT	NOT NULL, -- index?
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
ALTER TABLE Chromosome_Locations ADD CONSTRAINT chromLoc_loci_Accesssion
FOREIGN KEY (Genbank_Accession) REFERENCES Loci (Genbank_Accession) 
ON UPDATE CASCADE ON DELETE CASCADE;


-- ##load - > index
-- need auto increments on chrom id and exon id work out how these are dome
-- are there still mul keys - if so why?
