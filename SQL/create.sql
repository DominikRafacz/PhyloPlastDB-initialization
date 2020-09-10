CREATE DATABASE "PhyloPlastDB";

\c "PhyloPlastDB"


CREATE TYPE "ProductType" AS ENUM (
  'AA_product',
  'RNA_product'
);

CREATE TYPE "SequenceType" AS ENUM (
  'AA_sequence',
  'nucl_sequence',
  'tRNA_sequence',
  'rRNA_sequence'
);

CREATE TABLE "Organism" (
  "ID" SERIAL PRIMARY KEY,
  "Name" varchar NOT NULL,
  "TaxonomyString" varchar NOT NULL,
  "NBCICode" varchar
);

CREATE TABLE "GeneName" (
  "ID" SERIAL PRIMARY KEY,
  "Value" varchar
);

CREATE TABLE "AAProductName" (
  "ID" SERIAL PRIMARY KEY,
  "Value" varchar
);

CREATE TABLE "RNAProductName" (
  "ID" SERIAL PRIMARY KEY,
  "Value" varchar
);

CREATE TABLE "Product" (
  "ID" SERIAL PRIMARY KEY,
  "LocusTag" varchar,
  "Type" "ProductType" NOT NULL,
  "SequenceID" int NOT NULL,
  "OrganismID" int NOT NULL,
  "GeneNameID" int,
  "RNAProductNameID" int,
  "CodingSequenceID" int,
  "AAProductNameID" int
);

CREATE TABLE "Sequence" (
  "ID" SERIAL PRIMARY KEY,
  "Value" varchar NOT NULL,
  "NCBICode" varchar,
  "Type" "SequenceType" NOT NULL
);

ALTER TABLE "Product" ADD FOREIGN KEY ("SequenceID") REFERENCES "Sequence" ("ID");

ALTER TABLE "Product" ADD FOREIGN KEY ("OrganismID") REFERENCES "Organism" ("ID");

ALTER TABLE "Product" ADD FOREIGN KEY ("GeneNameID") REFERENCES "GeneName" ("ID");

ALTER TABLE "Product" ADD FOREIGN KEY ("RNAProductNameID") REFERENCES "RNAProductName" ("ID");

ALTER TABLE "Product" ADD FOREIGN KEY ("CodingSequenceID") REFERENCES "Sequence" ("ID");

ALTER TABLE "Product" ADD FOREIGN KEY ("AAProductNameID") REFERENCES "AAProductName" ("ID");
