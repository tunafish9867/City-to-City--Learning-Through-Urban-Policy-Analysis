# Load necessary libraries
library(readxl)  # For read_excel
library(dplyr)   # For data manipulation functions like mutate
library(stringr) # For string manipulation functions like str_c
library(tm)      # For text mining
library(SnowballC) # For stemming
library(quanteda)
library(geometry)
library(Rtsne)
library(rsvd)
library(stm)
library(matrixStats)  # for row-wise operations
library(DescTools)
library(rsconnect)
library(tidyverse)
library(tidyr)
library(tidytext)
library(tidyverse)
library(wordcloud)
library(visNetwork)
library(writexl)
library(LDAvis)

df_data <- read_excel("C:/Users/denis/Downloads/DATA (4).xlsx")

#Preprocessing Data
df_data$`Full Text` <- paste(df_data$`Ordinance Description`, df_data$`Full Text`)
df_data$`E-Governance Index` <- as.numeric(df_data$`E-Governance Index`)
df_data$`Overall CMCI Score` <- as.numeric(df_data$`Overall CMCI Score`)
df_data$City <- as.factor(df_data$City)


custom_stopwords <- c("pasay", "muntinlupa", "iloilo", "davao", "zamboanga", "las pinas", 
                      "paranaque", "cagayan de oro", "caloocan", "iligan", "pasig", "ordinance","city","marikina","barangay","quezon","makati","san juan","mandaluyong","malabon","manila","bacolod","mandaue","valenzuela","philippines","honorary","shall","honorable","whereas","section","honor","hon","marikina","gensan")
processed <- textProcessor(df_data$`Full Text`, metadata = df_data, lowercase = TRUE, removestopwords = TRUE, removenumbers = TRUE, removepunctuation =  TRUE, stem = TRUE, wordLengths = c(3,Inf), customstopwords = custom_stopwords) 

# Determine the number of documents each term appears in
calculate_term_document_counts <- function(documents, vocab) {
  # Initialize a vector to count document appearances for each term
  term_document_counts <- numeric(length(vocab))
  
  # Iterate over each document to count term appearances
  for (doc in documents) {
    unique_terms <- unique(doc)  # Get unique terms in the document
    term_document_counts[unique_terms] <- term_document_counts[unique_terms] + 1
  }
  
  # Create a data frame for better interpretability
  term_doc_count_df <- data.frame(
    term = vocab,
    document_count = term_document_counts,
    stringsAsFactors = FALSE
  )
  
  # Sort by document count (descending)
  term_doc_count_df <- term_doc_count_df[order(-term_doc_count_df$document_count), ]
  
  # Print summary statistics
  cat("\nSummary of term document counts:\n")
  print(summary(term_doc_count_df$document_count))
  
  # Visualize the distribution of document counts
  hist(term_doc_count_df$document_count, breaks = 50, main = "Term Document Count Distribution", 
       xlab = "Documents per Term", ylab = "Number of Terms", col = "lightblue")
  
  return(term_doc_count_df)
}


countPerDoc <- calculate_term_document_counts(processed$documents,processed$vocab)

#Using the median/1st quantile
out <- prepDocuments(processed$documents, processed$vocab, processed$meta, lower.thresh = 1)

k_range <- seq(20, 150, by = 25)
search_results_egovAndCMCI_1 <- searchK(out$documents, out$vocab, K = k_range, prevalence = ~out$meta$`Overall CMCI Score` + out$meta$`E-Governance Index`+out$meta$City, data = out$meta)

model_egovCityAndCMCI <- stm(out$documents, out$vocab, 95, prevalence = ~out$meta$`Overall CMCI Score` + out$meta$`E-Governance Index` + out$meta$City, data = out$meta, max.em.its = 112)

save(out, processed, model_egovCityAndCMCI,file="final_stm_models_4.RData")


shortdoc <- out$meta %>%
  mutate(`Full Text`=substr(`Full Text`,1,300))

thoughts <- findThoughts(model_egovCityAndCMCI, texts = shortdoc$`Full Text`, topics = 1:95, n=7)

thoughts_c <- as.list(thoughts$docs)
thoughts_df <- data.frame(
  Topic_Number = character(),
  Document_Text = character(),
  stringsAsFactors = FALSE
)
for (i in 1:95) {
  topic_name <- paste0("Topic ", i)  # Generate topic name (e.g., "Topic 1")
  for (di in 1:5) {
    text <- thoughts_c[[topic_name]][di]
    thoughts_df <- rbind(thoughts_df, data.frame(Topic_Number = topic_name, Document_Text = text))
  }
}
library(openxlsx)
wb <- createWorkbook()
addWorksheet(wb, "Overall Model")
writeData(wb, "Overall Model", thoughts_df)
write_xlsx(thoughts_df, path = "C:/Users/denis/OneDrive/Documents/000-FINAL SHINY/city_ordinances/Thoughts_3.xlsx")
plot.STM(model_egovCityAndCMCI, "labels",topics=1)

egov_effect <- estimateEffect(1:95 ~  `E-Governance Index`, model_egovCityAndCMCI, meta = out$meta, uncertainty = "Global")
summary(egov_effect)

plot.estimateEffect(egov_effect, covariate = "E-Governance Index", topics = 1:95, model = model_egovCityAndCMCI, method="continuous", main = "Effect of E-Governance Index on Topic Prevalence Across Ordinances",printlegend = F, xlab = "E-Governance Index")
cmci_effect <- estimateEffect(1:95 ~  `Overall CMCI Score`, model_egovCityAndCMCI, meta = out$meta, uncertainty = "Global")
summary(cmci_effect)
plot.estimateEffect(cmci_effect, covariate = "Overall CMCI Score", topics = 1:95, model = model_egovCityAndCMCI, method="continuous", main = "Effect of CMCI Score on Topic Prevalence Across Ordinances",printlegend = F, xlab = "CMCI Score")
city_effect <- estimateEffect(1:95 ~  `City`, model_egovCityAndCMCI, meta = out$meta, uncertainty = "Global")
city_effect_28 <- estimateEffect(25:28 ~  `City`, model_egovCityAndCMCI, meta = out$meta, uncertainty = "Global")
summary(city_effect_28)
combined_effect <- estimateEffect(1:95 ~  `E-Governance Index` + `Overall CMCI Score` + `City`, model_egovCityAndCMCI, meta = out$meta, uncertainty = "Global")
summary(combined_effect)
save(egov_effect, cmci_effect, city_effect, file="final_model_results_covariance_4.RData")

labelTopics(model_egovCityAndCMCI)
cloud(model_egovCityAndCMCI,10)
