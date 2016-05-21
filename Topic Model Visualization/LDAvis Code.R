#####################################################
########Creating an Interactive LDA Topic Model#######
#Author: Ryan Krog
#Date:4/1/2016

#Install Necessary Packages
install.packages("LDAvis")
install.packages('servr')
install.packages('tm')
devtools::install_github('rOpenSci/gistr')

#Load in the necessary libraries
library(servr)
library(lda)
library(LDAvis)
library(tm)
library(gistr)

#Change your working directory to where the story.csv is located
setwd('/Users/Copper/Git/DistrictDataLabs/04-team1/Topic Model Visualization')
stories <- read.csv("story.csv")
names(stories)

#List of stop words
stop_words <- stopwords("SMART")

# pre-processing:
reviews <- gsub("'", "", stories$content)  # remove apostrophes
reviews <- gsub("[[:punct:]]", " ", reviews)  # replace punctuation with space
reviews <- gsub("[[:cntrl:]]", " ", reviews)  # replace control characters with space
reviews <- gsub("^[[:space:]]+", "", reviews) # remove whitespace at beginning of documents
reviews <- gsub("[[:space:]]+$", "", reviews) # remove whitespace at end of documents
reviews <- tolower(reviews)  # force to lowercase
reviews <- gsub('[[:digit:]]+', '', reviews) #remove numbers


# tokenize on space and output as a list:
doc.list <- strsplit(reviews, "[[:space:]]+")

# compute the table of terms:
term.table <- table(unlist(doc.list))
term.table <- sort(term.table, decreasing = TRUE)

# remove terms that are stop words or occur fewer than 5 times:
del <- names(term.table) %in% stop_words | term.table < 5
term.table <- term.table[!del]
vocab <- names(term.table)

# now put the documents into the format required by the lda package:
get.terms <- function(x) {
  index <- match(x, vocab)
  index <- index[!is.na(index)]
  rbind(as.integer(index - 1), as.integer(rep(1, length(index))))
}
documents <- lapply(doc.list, get.terms)

# Compute some statistics related to the data set:
D <- length(documents)  # number of documents (3,736)
W <- length(vocab)  # number of terms in the vocab (238)
doc.length <- sapply(documents, function(x) sum(x[2, ]))  # number of tokens per document 
N <- sum(doc.length)  # total number of tokens in the data (546,827)
term.frequency <- as.integer(term.table)  # frequencies of terms in the corpus 

##Tuning parameters
K <- 12 #Number of topics
G <- 5000
alpha <- 0.02
eta <- 0.02

# Fit the model:
library(lda)
set.seed(357)
t1 <- Sys.time()
fit <- lda.collapsed.gibbs.sampler(documents = documents, K = K, vocab = vocab, num.iterations = G, alpha = alpha, eta = eta, initial = NULL, burnin = 0, compute.log.likelihood = TRUE)
t2 <- Sys.time()
t2 - t1  

theta <- t(apply(fit$document_sums + alpha, 2, function(x) x/sum(x)))
phi <- t(apply(t(fit$topics) + eta, 2, function(x) x/sum(x)))

storyLDA <- list(phi = phi, theta = theta, doc.length = doc.length, vocab = vocab, term.frequency = term.frequency)

# create the JSON object to feed the visualization:
json <- createJSON(phi = storyLDA$phi, 
                   theta = storyLDA$theta, 
                   doc.length = storyLDA$doc.length, 
                   vocab = storyLDA$vocab, 
                   term.frequency = storyLDA$term.frequency)

#Create the interactive graph
serVis(json, out.dir = 'vis2', open.browser = TRUE, as.gist=TRUE)




