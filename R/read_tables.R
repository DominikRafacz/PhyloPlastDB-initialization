rna_table <- read_tsv(
  paste0(.properties$SOURCE_DIR, "RefSeq/RefSeq_rna_table.tsv"), 
  col_names = c("GeneID", "locus_tag", "gene", "product", "organism"))

cds_table <- read_tsv(
  paste0(.properties$SOURCE_DIR, "RefSeq/RefSeq_cds_table.tsv"),
  col_names = c("GeneID", "proteinaccession", "locus_tag", "product", "organism"))

taxonomy_table <- read_tsv(
  paste0(.properties$SOURCE_DIR, "RefSeq/RefSeq_taxonomy.tsv"),
  col_names = c("Name", "TaxonomyString", "NCBICode")
)