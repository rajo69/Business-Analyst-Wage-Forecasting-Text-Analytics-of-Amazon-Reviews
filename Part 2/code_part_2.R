install.packages("dplyr")
install.packages("tm")
install.packages("stringr")
install.packages("RColorBrewer")
install.packages("wordcloud")
install.packages("topicmodels")
install.packages("ggplot2")
install.packages("LDAvis")
install.packages("servr")
install.packages("textcat")
install.packages("jsonlite")
install.packages("ldatuning")

library(stats)
library(dplyr) # basic data manipulation
library(tm) # package for text mining package
library(stringr) # package for dealing with strings
library(RColorBrewer)# package to get special theme color
library(wordcloud) # package to create wordcloud
library(topicmodels) # package for topic modelling
library(ggplot2) # basic data visualization
library(LDAvis) # LDA specific visualization 
library(servr) # interactive support for LDA visualization
library(textcat)
library(jsonlite)
library(NLP)


#Downloading all data
data  <- fromJSON("https://query.data.world/s/4ria2tfww73wmhfzke5z2w4zlez2re")

#Fetching my data
set.seed(225)
reviews <-sample_n(data, 5000)

#Unique ratings
unique(reviews$review_rating)

#String to int conversion of ratings
reviews$rating <- as.numeric(str_sub(reviews$review_rating,1,1))
summary(reviews)

#Dropping Neutral Reviews and NULL values
reviews_final <- reviews[reviews$rating != 3, ]

reviews_final_corp <- reviews_final[, c("rating", "review_text")]

neg_set <- reviews_final_corp[reviews_final_corp$rating < 3,]
pos_set <- reviews_final_corp[reviews_final_corp$rating > 3,]

#Inspecting the reviews
head(pos_set,1)
head(neg_set,1)

#Correct encoding
pos_reviews <- stringr::str_conv(pos_set$review_text, "UTF-8")
pos_docs <- Corpus(VectorSource(pos_reviews))
neg_reviews <- stringr::str_conv(neg_set$review_text, "UTF-8")
neg_docs <- Corpus(VectorSource(neg_reviews))

pos_dtmdocs <- DocumentTermMatrix(pos_docs,
                                  control = list(lemma=TRUE,removePunctuation = TRUE,
                                                 removeNumbers = TRUE, stopwords = TRUE,
                                                 tolower = TRUE))
pos_raw.sum=apply(pos_dtmdocs,1,FUN=sum)
pos_dtmdocs=pos_dtmdocs[pos_raw.sum!=0,]
neg_dtmdocs <- DocumentTermMatrix(neg_docs,
                                  control = list(lemma=TRUE,removePunctuation = TRUE,
                                                 removeNumbers = TRUE, stopwords = TRUE,
                                                 tolower = TRUE))
neg_raw.sum=apply(neg_dtmdocs,1,FUN=sum)
neg_dtmdocs=neg_dtmdocs[neg_raw.sum!=0,]

#Positive word cloud
library(wordcloud)
pos_dtm.new <- as.matrix(pos_dtmdocs)
pos_frequency <- colSums(pos_dtm.new)
pos_frequency <- sort(pos_frequency, decreasing=TRUE)
pos_doc_length <- rowSums(pos_dtm.new)

pos_frequency[1:10]

pos_words <- names(pos_frequency)

wordcloud(pos_words[1:100], pos_frequency[1:100], rot.per=0.15, 
          random.order = FALSE, scale=c(4,0.5),
          random.color = FALSE, colors=brewer.pal(8,"Dark2"))
title(main = "Positive review wordcloud")

#Negative word cloud
neg_dtm.new <- as.matrix(neg_dtmdocs)
neg_frequency <- colSums(neg_dtm.new)
neg_frequency <- sort(neg_frequency, decreasing=TRUE)
neg_doc_length <- rowSums(neg_dtm.new)

neg_frequency[1:10]

neg_words <- names(neg_frequency)

wordcloud(neg_words[1:100], neg_frequency[1:100], rot.per=0.15, 
          random.order = FALSE, scale=c(4,0.5),
          random.color = FALSE, colors=brewer.pal(8,"Dark2"))
title(main = "Negative review wordcloud")

#Determining number of topics (positive)
library(ldatuning)
pos_result <- FindTopicsNumber(
  pos_dtm.new,
  topics = seq(from = 2, to = 20, by = 1),
  metrics = c("Griffiths2004", "CaoJuan2009", "Arun2010"),
  method = "Gibbs",
  control = list(seed = 430),
  mc.cores = 2L,
  verbose = TRUE
)
FindTopicsNumber_plot(pos_result)

#Determining number of topics (negative)
neg_result <- FindTopicsNumber(
  neg_dtm.new,
  topics = seq(from = 2, to = 20, by = 1),
  metrics = c("Griffiths2004", "CaoJuan2009", "Arun2010"),
  method = "Gibbs",
  control = list(seed = 430),
  mc.cores = 2L,
  verbose = TRUE
)
FindTopicsNumber_plot(neg_result)

#Topic modelling
library(dplyr)
pos_ldaOut <-LDA(pos_dtmdocs,7, method="Gibbs", 
                 control=list(iter=1000,seed=430))
neg_ldaOut <-LDA(neg_dtmdocs,9, method="Gibbs", 
                 control=list(iter=1000,seed=430))

#Positive topic labeling
pos_ldaOut.terms <- as.matrix(terms(pos_ldaOut, 10))
pos_ldaOut.terms

#Negative topic labeling
neg_ldaOut.terms <- as.matrix(terms(neg_ldaOut, 10))
neg_ldaOut.terms

#Top 3 factors in Positive reviews visualized
library(ggplot2)
pos_ldaOut.topics <- data.frame(topics(pos_ldaOut))
pos_ldaOut.topics$index <- as.numeric(row.names(pos_ldaOut.topics))
ggplot(pos_ldaOut.topics, aes(x = topics.pos_ldaOut.)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Count Plot for Positive Review topics", x = "Topic", y = "Count") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 15, face = "bold"),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12)
  )

#Top 3 factors in Negative reviews visualized
neg_ldaOut.topics <- data.frame(topics(neg_ldaOut))
neg_ldaOut.topics$index <- as.numeric(row.names(neg_ldaOut.topics))
ggplot(neg_ldaOut.topics, aes(x = topics.neg_ldaOut.))+
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Count Plot for Negative Review topics", x = "Topic", y = "Count") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 15, face = "bold"),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12)
  )
