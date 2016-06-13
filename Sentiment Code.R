#Create Sentiment Graphs from News Articles about Candidates 
#Author: Ryan Krog
#Date: 4/18/2016

library(quanteda)
library(stringr)
library(syuzhet)
library(ggplot2)
library(plotly)

#Load in the files through the directory
#Creates 3 document-level variables
stories <- textfile("~/Dropbox/Combined/*.txt",  docvarsfrom="filenames", dvsep="_", docvarnames=c("Article", "Date", "Category"))

#Create a corpus and inspect its structure
storyCorpus <- corpus(stories) 
summary(storyCorpus, n=5)

docvars(storyCorpus, "Trump") <- ifelse(grepl("Trump", storyCorpus$documents$text),1,0)
docvars(storyCorpus, "Clinton") <- ifelse(grepl("Clinton", storyCorpus$documents$text),1,0)
docvars(storyCorpus, "Cruz") <- ifelse(grepl("Cruz", storyCorpus$documents$text),1,0)
docvars(storyCorpus, "Sanders") <- ifelse(grepl("Sanders", storyCorpus$documents$text),1,0)
docvars(storyCorpus, "Kasich") <- ifelse(grepl("Kasich", storyCorpus$documents$text),1,0)

#Create a "Sentiment Score" for each news story
docvars(storyCorpus, "Sentiment") <- get_sentiment(storyCorpus$documents$texts, method="afinn")



library (plyr)
library (stringr)

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')  
{  
  require(plyr)  
  require(stringr)       
  
  # we got a vector of sentences. plyr will handle a list  
  # or a vector as an "l" for us  
  # we want a simple array ("a") of scores back, so we use   
  # "l" + "a" + "ply" = "laply":  
  
  scores = laply(sentences, function(sentence, pos.words, neg.words) {  
    
    # clean up sentences with R's regex-driven global substitute, gsub():  
    
    sentence = gsub('[[:punct:]]', '', sentence)  
    
    sentence = gsub('[[:cntrl:]]', '', sentence)  
    
    sentence = gsub('\\d+', '', sentence)  
    
    # and convert to lower case:  
    
    sentence = tolower(sentence)  
    
    # split into words. str_split is in the stringr package  
    
    word.list = str_split(sentence, '\\s+')  
    
    # sometimes a list() is one level of hierarchy too much  
    
    words = unlist(word.list)  
    
    # compare our words to the dictionaries of positive & negative terms  
    
    pos.matches = match(words, pos.words)  
    neg.matches = match(words, neg.words)  
    
    # match() returns the position of the matched term or NA  
    # we just want a TRUE/FALSE:  
    
    pos.matches = !is.na(pos.matches)  
    
    neg.matches = !is.na(neg.matches)  
    
    # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():  
    
    score = sum(pos.matches) - sum(neg.matches)  
    
    return(score)  
    
  }, pos.words, neg.words, .progress=.progress )  
  scores.df = data.frame(score=scores, text=sentences)  
  return(scores.df)  
} 

#Load sentiment word lists
hu.liu.pos = scan('~/Dropbox/Text Analysis/positive-words.txt', what='character', comment.char=';')
hu.liu.neg = scan('~/Dropbox/Text Analysis/negative-words.txt', what='character', comment.char=';')

#Add words to list
pos.words = c(hu.liu.pos)
neg.words = c(hu.liu.neg)


storyCorpus$documents$texts[1]


Article.scores <- score.sentiment(storyCorpus$documents$texts, pos.words,neg.words, .progress='text')

docvars(storyCorpus, "ArticleSentiment") <- Article.scores$score
summary(storyCorpus, n=5)

storyCorpus[529]

#Update dataset to include the new readability grade variables
tokenInfo <- summary(storyCorpus, n=2668)
tokenInfo$Date <- as.Date(tokenInfo$Date, '%Y-%m-%d')

View(tokenInfo)

###Plot the distrubtion of sentiment scores across the candiates
ClintonPlotDensity <- ggplot(data = subset(tokenInfo, Clinton==1), aes(Sentiment)) + geom_density(aes(x = Sentiment, y=..density..), fill="blue", colour="black", alpha = 0.7) + ggtitle("Sentiment Distribution of Articles about Hillary Clinton") +  theme(plot.title = element_text(lineheight=.8, face="bold")) + expand_limits(x=c(-150,150)) +  theme_classic() 
ClintonPlotDensity

ClintonPlotDensity <- ggplot(data = subset(tokenInfo, Clinton==1), aes(Sentiment)) + geom_density(aes(x = Sentiment, y=..density..), fill="blue", colour="black", alpha = 0.7) + ggtitle("Sentiment Distribution of Articles about Hillary Clinton") +  theme(plot.title = element_text(lineheight=.8, face="bold")) + expand_limits(x=c(-150,150)) +  theme_classic() 
ClintonPlotDensity


CruzPlotDensity <- ggplot(data = subset(tokenInfo, Cruz==1), aes(x=Sentiment)) + geom_density(aes(x = Sentiment, y=..density..), fill="#990000", colour="black", alpha = 0.7) + ggtitle("Sentiment Distribution of Articles about Ted Cruz") +  theme(plot.title = element_text(lineheight=.8, face="bold")) +  expand_limits(x=c(-150,150)) +  theme_classic() 

TrumpPlotDensity <- ggplot(data = subset(tokenInfo, Trump==1), aes(x=Sentiment)) + geom_density(aes(x = Sentiment, y=..density..), fill="red", colour="black", alpha = 0.7) + ggtitle("Sentiment Distribution of Articles about Donald Trump") +  theme(plot.title = element_text(lineheight=.8, face="bold")) +  expand_limits(x=c(-150,150)) +  theme_classic() 

SandersPlotDensity <- ggplot(data = subset(tokenInfo, Sanders==1), aes(x=Sentiment)) + geom_density(aes(x = Sentiment, y=..density..), fill="navy", colour="black", alpha = 0.7) + ggtitle("Sentiment Distribution of Articles about Bernie Sanders") +  theme(plot.title = element_text(lineheight=.8, face="bold")) +  expand_limits(x=c(-150,150)) +  theme_classic() 


KasichPlotDensity <- ggplot(data = subset(tokenInfo, Kasich==1), aes(x=Sentiment)) + geom_density(aes(x = Sentiment, y=..density..), fill="navy", colour="black", alpha = 0.7) + ggtitle("Sentiment Distribution of Articles about Bernie Sanders") +  theme(plot.title = element_text(lineheight=.8, face="bold")) +  expand_limits(x=c(-150,150)) +  theme_classic() 




#Creating a second sentiment variable for visual color scaling
tokenInfo$Sentiment2 <- tokenInfo$Sentiment

#PLOT THE SENTIMENT ACROSS TIME

TrumpPlot <- ggplot(data = subset(tokenInfo, Trump==1), aes(x=Date, y=Sentiment)) + geom_point(aes(colour = Sentiment2), size = I(2)) + geom_smooth(aes(group=1), se=FALSE, color="Navy") + scale_colour_gradient2("Level of\nSentiment") +  theme_classic() +  theme(panel.background = element_rect(colour = 'black', size = 1, linetype='solid')) + ggtitle("Sentiment over Time in Political Media about Donald Trump") + expand_limits(y=c(-75,75)) + theme(legend.position="none")
TrumpPlot 

CruzPlot <-ggplot(data = subset(tokenInfo, Cruz==1), aes(x=Date, y=ArticleSentiment)) + geom_point(aes(colour = ArticleSentiment), size = I(2)) + geom_smooth(aes(group=1), se=FALSE, color="Navy") + scale_colour_gradient2("Level of\nSentiment") +  theme_classic() +  theme(panel.background = element_rect(colour = 'black', size = 1, linetype='solid')) + ggtitle("Sentiment over Time in Political Media about Ted Cruz") + expand_limits(y=c(-75,75)) + theme(legend.position="none")
CruzPlot

ClintonPlot <-ggplot(data = subset(tokenInfo, Clinton==1), aes(x=Date, y=Sentiment)) + geom_point(aes(colour = Sentiment2), size = I(2)) + geom_smooth(aes(group=1), se=FALSE, color="Navy") + scale_colour_gradient2("Level of\nSentiment") +  theme_classic() +  theme(panel.background = element_rect(colour = 'black', size = 1, linetype='solid')) + ggtitle("Sentiment over Time in Political Media about Hillary Clinton") + expand_limits(y=c(-75,75)) + theme(legend.position="none")
ClintonPlot


SandersPlot <-ggplot(data = subset(tokenInfo, Sanders==1), aes(x=Date, y=Sentiment)) + geom_point(aes(colour = Sentiment2), size = I(2)) + geom_smooth(aes(group=1), se=FALSE, color="Navy") + scale_colour_gradient2("Level of\nSentiment") +  theme_classic() +  theme(panel.background = element_rect(colour = 'black', size = 1, linetype='solid')) + ggtitle("Sentiment over Time in Political Media about Bernie Sanders") + expand_limits(y=c(-75,75)) + theme(legend.position="none")
SandersPlot


KasichPlot <-ggplot(data = subset(tokenInfo, Kasich==1), aes(x=Date, y=Sentiment)) + geom_point(aes(colour = Sentiment2), size = I(2)) + geom_smooth(aes(group=1), se=FALSE, color="Navy") + scale_colour_gradient2("Level of\nSentiment") +  theme_classic() +  theme(panel.background = element_rect(colour = 'black', size = 1, linetype='solid')) + ggtitle("Sentiment over Time in Political Media about John Kasich") + expand_limits(y=c(-75,75)) + theme(legend.position="none")
KasichPlot


#Log in to the Plotly system to share
Sys.setenv("plotly_username"="")
Sys.setenv("plotly_api_key"="")

plotly_POST(multi, "Density Plots")
plotly_POST(ClintonPlot, "Clinton Plot")
plotly_POST(CruzPlot, "Cruz Plot")
plotly_POST(TrumpPlot, "Trump Plot")
plotly_POST(SandersPlot, "Sanders Plot")

plotly_POST(ClintonPlotDensity, "Clinton Density Plot")
plotly_POST(CruzPlotDensity, "Cruz Density Plot")
plotly_POST(TrumpPlotDensity, "Trump Density Plot")
plotly_POST(SandersPlotDensity, "Sanders Density Plot")


TrumpCorpus <- subset(storyCorpus, Trump == 1)
mydfm <- dfm(TrumpCorpus, ignoredFeatures=c("Trump", "caption", stopwords("english")))
plot(mydfm)

if (require(RColorBrewer))
  plot(mydfm, max.words = 200, colors = brewer.pal(12, "RdBu"), scale = c(8, .5))
