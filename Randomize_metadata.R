################Bacteria

ps <- readRDS("AMS_phyloseq.RDS")

df <- data.frame(sample_data(ps))

# Columns to not randomize
keep.cols <- c("Timepoint","Study_group")

columns <- colnames(df)
columns_to_randomize <- columns[!columns %in% keep.cols]

set.seed(123)  # For reproducibility
# Replace values in specified columns with appropriate random values
for (col_name in columns_to_randomize) {
  if (is.numeric(df[[col_name]])) {
    # Numeric columns: Replace with random values from the same distribution
    mean_val <- mean(df[[col_name]], na.rm = TRUE)
    sd_val <- sd(df[[col_name]], na.rm = TRUE)
    df[[col_name]] <- rnorm(n = nrow(df), mean = mean_val, sd = sd_val)
  } else if (is.character(df[[col_name]])) {
    # Character columns: Shuffle the values
    df[[col_name]] <- sample(df[[col_name]])
  }
}

sample_data(ps) <- df

write_tsv(df,"AMS_phyloseq_randomized.RDS")
