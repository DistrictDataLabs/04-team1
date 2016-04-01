# 04-team1
Repository for Incubator 4 Team 1

##Data Source
The source of the data set a corpus of news and blog posts ingested using Baleen (http://bit.ly/1UvS6ee) from the period March 3, 2016, ongoing. Currently the data set contains 52k+ articles in HTML format for a size of approximately 3.6 GB. The corpus is growing at a rate of several thousand posts per day.

This data set was provided to the team as a mongo dump by Benjamin Bengfort.  We loaded the mongo dump into a local MongoDB data store.  The MongoDB data store contains three tables (these are referred to as collections in MongoDB).  The collection of interest is called "posts", which is the table that contains the urls as well as the content of the news and blog posts

## Document Retrieval
We decided to use the Python package called "newspaper" to convert the html documents into text files so that they can be used to form a corpus that will be used for natural language processing.  The input for newspaper is a url, which it uses to go the specific web page, download the html document, and parse the document into a readable text file.  Therefore, the field of interest from the posts collection in the MongoDB database is the "url" field.  We used mongoexport to download a sample of urls into a file that are subsequently used as inputs to the newspaper package.

xxx.

## MVP

The MVP is a jupyter notebook where we perform exploratory data analysis on these .txt files. They were imported as a corpus and turned into a list. After, the list was normalized. We kept only words (omitted punctuation), transformed all the letters to lowercase, kept only words that appeared more than once in the document, and removed both common and custom stopwords (i.e. caption, image, and copyright). The words were also stemmed using the Porter method, which will be reevaluated later. Then, we computed the frequency distribution for the words and plotted the top 50 descriptive words. These words were also used to create a dispersion plot.

Separately, we also tagged the words in the documents to identify part of speech. Using these parts of speech, we hope to improve upon the named entity recognition results. As many of our important words will most likely be proper nouns, it will be helpful to have recognized patterns like "bin laden" as single entities. We would like to use the relationships between these entities in the final product.

## Next Steps

In the next few days, we will do similar computations on sentences and create trees. Additionally, we hope to investigate bigrams (n-grams), which may aid in finding entities. Finally, we could potentially look into word length distribution for lexical complexity.

##Final Product

Interactive data visualization tool to gather information from news stories

![Alt text](http://dclure.org/wp-content/uploads/2014/12/timeline.jpg "Target Visualization")
