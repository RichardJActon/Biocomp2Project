/*
=pod

=head1 Database Creation Script for Chromosome17

=begin html

<p><a href="./index.html">home</a></p>

=end html

=head2 Synopsis

This script creates the database underpinning the "Explore Chromosome 17" website. The Database has three tables

=over

=item *
Chromosome_Locations

=item *
Loci

=item *
Exons

=back

The Locical Schema of the database in represented in the UML diagram below:

=begin html

<p><img src="./Logical_Data_Model.PNG" alt="Logical Data Model"></p>

=end html



This version is for creating a database on a local machine. Changes had to be made to accommodate the limited permissions
available on the Birkbeck server, for example the entire database cannot be dropped on the Birkbeck server so each table
is dropped individually if they already exist in that version.

=head2 Arguments

=over

=item *
Database login information

=back

=head2 Returns

Creates a database called Chromosome17 with the tables and fields: 

=over

=item *
Chromosomes_Locations

=over

=item *
Genbank_Accession (FK)

=item *
Location_Name

=back

=item *
Loci

=over

=item *
Genbank_Accesssion (PK)

=item *
Locus_GI

=item *
DNA_seq

=item *
Product_Name

=item *
CDS_translated

=item *
CDS_untranslated

=item *
Reading_Frame

=back

=item *
Exons

=over

=item *
Genbank_Accession (FK)

=item *
StartPosition

=item *
EndPosition

=item *
Exon_ID (Auto increment)

=back

=back


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
	Reading_Frame			SMALLINT	NOT NULL,
	PRIMARY KEY (Genbank_Accession)
)ENGINE = INNODB;

CREATE TABLE Exons
(	Genbank_Accession	VARCHAR(15)	DEFAULT NULL,
	StartPosition		SMALLINT	NOT NULL,
	EndPosition			SMALLINT	NOT NULL,
	Exon_ID				SMALLINT	NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (Exon_ID)
)ENGINE = INNODB;  

ALTER TABLE Exons ADD CONSTRAINT exon_loci_Accession
FOREIGN KEY (Genbank_Accession) REFERENCES Loci (Genbank_Accession) 
ON UPDATE CASCADE ON DELETE CASCADE;
-- 
ALTER TABLE Chromosome_Locations ADD CONSTRAINT chromLoc_loci_Accesssion
FOREIGN KEY (Genbank_Accession) REFERENCES Loci (Genbank_Accession) 
ON UPDATE CASCADE ON DELETE CASCADE;
