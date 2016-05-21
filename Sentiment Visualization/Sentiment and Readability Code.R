library(quanteda)
library(stringr)
library(syuzhet)
library(ggplot2)
library(foreign)
library(gistr)

#Load the CSV 
setwd('/Users/Copper/Git/DistrictDataLabs/04-team1/Combined')
stories <- textfile("*.txt", full.names = TRUE)

##Create corpus called "speechCorpus"
storyCorpus <- corpus(stories) 

#Get Summary of Documents 
#This will look a normal structured text document
summary(storyCorpus, n=5) 
#Corpus consisting of 239 documents, showing 5 documents

#extract text from a corpus
texts(storyCorpus)[2] 
texts(storyCorpus)[5] 

#Keywords in context
kwic(storyCorpus, "Trump")

##Measure the readability of the texts
docvars(storyCorpus, "readability")  <- readability(storyCorpus, measure = "Flesch")
docvars(storyCorpus, "readabilityGrade")  <- readability(storyCorpus, measure = "Flesch.Kincaid")
#The first variable is titled "readiability" 
#The second variable is titled "readabilityGrade" 
#The command itself is "readability()"

#Preview to ensure that the variables have been created
summary(storyCorpus, n=5) 

#Create a dataframe
tokenInfo <- summary(storyCorpus)

#Plot the distribution of the readabiality scores 
ggplot(tokenInfo, aes(x=readabilityGrade)) + geom_histogram(binwidth=.5, fill="#99badd", colour="black") +   theme(panel.background = element_rect(colour = 'black', size = 1, linetype='solid'))  +  labs(x="Readability Score",y="Frequency") 


#Create a "Sentiment Score" for each news story
docvars(storyCorpus, "Sentiment") <- get_sentiment(storyCorpus$documents$texts, method="afinn")
#The command is "get_sentiment()". It comes from the syuzhet package


#Preview to ensure that the variables have been created
summary(storyCorpus, n=5) 

#Update dataset to include the new readability grade variables
tokenInfo <- summary(storyCorpus)

###Generate emotional content of speeches

nrc_data <- get_nrc_sentiment(storyCorpus$documents$texts)
names(nrc_data)
View(nrc_data)

docvars(storyCorpus, "anger") <- nrc_data$anger
docvars(storyCorpus, "trust") <- nrc_data$trust
docvars(storyCorpus, "disgust") <- nrc_data$disgust
docvars(storyCorpus, "joy") <- nrc_data$joy
docvars(storyCorpus, "fear") <- nrc_data$fear
docvars(storyCorpus, "sadness") <- nrc_data$sadness
docvars(storyCorpus, "anticipation") <- nrc_data$anticipation

tokenInfo <- summary(storyCorpus)


barplot(
  sort(colSums(prop.table(nrc_data[, 1:8]))), 
  horiz = TRUE, 
  cex.names = 0.7, 
  las = 1, 
  main = "Emotions in News Articles", xlab="Percentage"
)

#Plot the distribution of the sentiment scores 
ggplot(tokenInfo, aes(x=Sentiment)) + geom_histogram(binwidth=4, fill="#99badd", colour="black") +   theme(panel.background = element_rect(colour = 'black', size = 1, linetype='solid'))  +  labs(x="Sentiment Score",y="Frequency") 

###Plotting the Emotions of News Stories

p1 <- ggplot(tokenInfo, aes(x=fear)) + geom_histogram(binwidth=3, fill="#99badd", colour="black") +   theme(panel.background = element_rect(colour = 'black', size = 1, linetype='solid'))  +  labs(x="Sentiment Score",y="Frequency") + expand_limits(x=c(0,50)) + ggtitle("Fear") +  theme(plot.title = element_text(lineheight=.8, face="bold"))

p2 <- ggplot(tokenInfo, aes(x=anger)) + geom_histogram(binwidth=3, fill="#99badd", colour="black") +   theme(panel.background = element_rect(colour = 'black', size = 1, linetype='solid'))  +  labs(x="Sentiment Score",y="Frequency") + expand_limits(x=c(0,50)) + ggtitle("Anger") +  theme(plot.title = element_text(lineheight=.8, face="bold"))

p3 <- ggplot(tokenInfo, aes(x=sadness)) + geom_histogram(binwidth=3, fill="#99badd", colour="black") +   theme(panel.background = element_rect(colour = 'black', size = 1, linetype='solid'))  +  labs(x="Sentiment Score",y="Frequency") + expand_limits(x=c(0,50)) + ggtitle("Sadness") +  theme(plot.title = element_text(lineheight=.8, face="bold"))

p4 <- ggplot(tokenInfo, aes(x=joy)) + geom_histogram(binwidth=3, fill="#99badd", colour="black") +   theme(panel.background = element_rect(colour = 'black', size = 1, linetype='solid'))  +  labs(x="Sentiment Score",y="Frequency") + expand_limits(x=c(0,50)) + ggtitle("Joy") +  theme(plot.title = element_text(lineheight=.8, face="bold"))




multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


multiplot(p1, p2, p3, p4, cols=2)




