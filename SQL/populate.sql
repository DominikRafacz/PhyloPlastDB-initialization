\copy "Sequence" FROM 'output/Sequence.csv' DELIMITER ',' CSV HEADER;

\copy "AAProductName" FROM 'output/AAProductName.csv' DELIMITER ',' CSV HEADER;

\copy "RNAProductName" FROM 'output/RNAProductName.csv' DELIMITER ',' CSV HEADER;

\copy "GeneName" FROM 'output/GeneName.csv' DELIMITER ',' CSV HEADER;

\copy "Organism" FROM 'output/Organism.csv' DELIMITER ',' CSV HEADER;

\copy "Product" FROM 'output/Product.csv' DELIMITER ',' CSV HEADER;
