# 04-team1
Repository for Incubator 4 Team 1

## Document Retrieval

xxx.

## MVP

The MVP is a jupyter notebook where we perform exploratory data analysis on these .txt files. They were imported as a corpus and turned into a list. After, the list was normalized. We kept only words (omitted punctuation), transformed all the letters to lowercase, kept only words that appeared more than once in the document, and removed both common and custom stopwords (i.e. caption, image, and copyright). The words were also stemmed using the Porter method, which will be reevaluated later. Then, we computed the frequency distribution for the words and plotted the top 50 descriptive words. These words were also used to create a dispersion plot.

Separately, we also tagged the words in the documents to identify part of speech. Using these parts of speech, we hope to improve upon the named entity recognition results. As many of our important words will most likely be proper nouns, it will be helpful to have recognized patterns like "bin laden" as single entities. We would like to use the relationships between these entities in the final product.

## Next Steps

In the next few days, we will do similar computations on sentences and create trees. Additionally, we hope to investigate bigrams (n-grams), which may aid in finding entities. Finally, we could potentially look into word length distribution for lexical complexity.

##Final Product

Interactive data visualization tool to gather information from news stories

![Alt text](http://dclure.org/wp-content/uploads/2014/12/timeline.jpg "Target Visualization")
