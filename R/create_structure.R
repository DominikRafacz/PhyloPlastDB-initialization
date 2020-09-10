Organism <- taxonomy_table %>%
  mutate(ID = cur_group_rows()) %>%
  relocate(ID, Name, TaxonomyString, NCBICode)

GeneName <- rna_table %>%
  select(Value = gene)  %>%
  distinct(Value) %>%
  mutate(ID = cur_group_rows()) %>%
  relocate(ID, Value)


RNAProductName <- rna_table %>%
  select(Value = product) %>%
  distinct(Value) %>%
  mutate(ID = cur_group_rows()) %>%
  relocate(ID, Value)

AAProductName <- cds_table %>%
  select(Value = product) %>%
  distinct(Value) %>%
  mutate(ID = cur_group_rows()) %>%
  relocate(ID, Value)

Sequence <- rna_table %>%
  select(NCBICode = GeneID) %>%
  rbind(
    cds_table %>%
      select(NCBICode = GeneID) %>%
      mutate(NCBICode = format(NCBICode, scientific = FALSE, trim = TRUE)),
    cds_table %>%
      select(NCBICode = proteinaccession)) %>%
  distinct() %>%
  filter(!is.na(NCBICode)) %>%
  mutate(ID = cur_group_rows(),
         Value = NA_character_,
         Type = NA_character_) %>%
  relocate(ID, Value, NCBICode)

RNAProduct <- rna_table %>%
  mutate(GeneID = format(GeneID, scientific = FALSE, trim = TRUE)) %>%
  left_join(Sequence, by = c("GeneID" = "NCBICode")) %>%
  select(-GeneID,
         -Value,
         SequenceID = ID) %>%
  left_join(Organism, c("organism" = "Name")) %>%
  select(-organism, 
         -TaxonomyString, 
         -NCBICode, 
         OrganismID = ID) %>%
  left_join(GeneName, c("gene" = "Value")) %>%
  select(-gene, 
         GeneNameID = ID) %>%
  left_join(RNAProductName, c("product" = "Value")) %>%
  select(-product, 
         RNAProductNameID = ID,
         LocusTag = locus_tag) %>%
  mutate(ID = cur_group_rows(),
         Type = "RNA_product",
         AAProductNameID = NA_real_,
         CodingSequenceID = NA_real_) %>%
  relocate(ID,
           LocusTag,
           Type,
           SequenceID,
           OrganismID,
           GeneNameID,
           RNAProductNameID,
           CodingSequenceID,
           AAProductNameID)


AAProduct <- cds_table %>%
  mutate(GeneID = format(GeneID, scientific = FALSE, trim = TRUE)) %>%
  left_join(Sequence, by = c("GeneID" = "NCBICode")) %>%
  select(-GeneID,
         -Value,
         -Type,
         SequenceID = ID) %>%
  left_join(Sequence, by = c("proteinaccession" = "NCBICode")) %>%
  select(-proteinaccession,
         -Value,
         -Type,
         CodingSequenceID = ID) %>%
  left_join(Organism, c("organism" = "Name")) %>%
  select(-organism, 
         -TaxonomyString, 
         -NCBICode, 
         OrganismID = ID) %>%
  left_join(AAProductName, c("product" = "Value")) %>%
  select(-product, 
         AAProductNameID = ID,
         LocusTag = locus_tag) %>%
  mutate(ID = cur_group_rows() + nrow(RNAProduct),
         Type = "AA_product",
         RNAProductNameID = NA_real_,
         GeneNameID = NA_real_) %>%
  relocate(ID,
           LocusTag,
           Type,
           SequenceID,
           OrganismID,
           GeneNameID,
           RNAProductNameID,
           CodingSequenceID,
           AAProductNameID)

Product <- rbind(RNAProduct, AAProduct)
rm(cds_table, 
   rna_table,
   taxonomy_table,
   AAProduct,
   RNAProduct)
