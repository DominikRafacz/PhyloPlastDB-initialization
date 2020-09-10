files <- list.files(paste0(.properties$SOURCE_DIR, "RefSeq/sequences"))
files_splitted_names <- stri_match_first_regex(files, "(.*)(?>_aa\\.fasta)")[, 2] %>% .[!is.na(.)]
rm(files)

#####

c.seq_ext <- function(...) {
  objs <- list(...)
  ret <- list()
  ret$seqs <- do.call(c, lapply(objs, function(elem) elem$seqs))
  ret$type <- do.call(c, lapply(objs, function(elem) elem$type))
  class(ret) <- "seq_ext"
  ret
}

read_sequences <- function(NCBIOrganismID, type) {
  ret <- list()
  ret$seqs <- readAAStringSet(
    paste0(.properties$SOURCE_DIR, "RefSeq/sequences/", NCBIOrganismID, "_", type, ".fasta")
  )
  ret$type <- rep(type, length(ret$seqs))
  class(ret) <- "seq_ext"
  ret
}

sequences <- do.call(c, lapply(files_splitted_names, function(NCBIOrganismID) 
  c(
    read_sequences(NCBIOrganismID, "aa"),
    read_sequences(NCBIOrganismID, "nucl"),
    read_sequences(NCBIOrganismID, "rrna"),
    read_sequences(NCBIOrganismID, "trna")
  )
))


Sequence <- Sequence %>%
  left_join(
    tibble(value = as.character(sequences$seqs),
           code = names(sequences$seqs),
           type = sequences$type) %>%
      distinct(code, .keep_all = TRUE),
    by = c("NCBICode" = "code")) %>%
  mutate(Type = if_else(type == "aa","AA_sequence",
                        if_else(type == "nucl", "nucl_sequence",
                                if_else(type == "trna", "tRNA_sequence",
                                        if_else(type == "rrna", "rRNA_sequence", NA_character_))))) %>%
  select(ID, 
         Value = value, 
         NCBICode,
         Type)

rm(c.seq_ext, 
   read_sequences,
   files_splitted_names,
   sequences)
