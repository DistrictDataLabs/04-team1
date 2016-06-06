#!/usr/bin/python
#See more at: https://labs.opendns.com/2014/08/28/hackers-manifesto-revisited/#sthash.b5uAPOuo.dpuf
#http://www.nltk.org/book/ch02.html
import nltk
from nltk import FreqDist
from nltk.corpus import stopwords
import re
from collections import Counter
import semanticnet as sn
import json
import csv
import sys
import os
			
input_dir 		= sys.argv[1]
output_root_dir	= sys.argv[2]

words = []
stopwords = nltk.corpus.stopwords.words('english')
other_stop_words = ['also', 'years', 'around', 'think', 'since', 'people', 'three', 'first', 'could', 'still', 'said', 'would', 'one', 'said.', 'monday', 'tuesday', 'state', 'going', 'may', 'might', 'another', 'found', 'according', 'called', 'found', 'really', 'never', 'story']
custom_stop_words = stopwords + other_stop_words

for root, dirs, files in os.walk(input_dir):
	for filename in files:
		try:
			print "name: ", filename
			fullpath = os.path.join(input_dir, filename)
			infile = open(fullpath,'r')
			text = infile.read()
			#print text
			words.append(text) 
			#print words
		except:
			pass
		
	
file_text = ''.join(words)	
text_tokens = nltk.word_tokenize(file_text)
text = nltk.Text(text_tokens)
nonPunct = re.compile('.*[A-Za-z].*')
raw_words = [w for w in text if nonPunct.match(w)]
filtered_words = [w for w in raw_words if len(w) > 4]
raw_word_count = Counter(raw_words)
# stop words
no_stop_words = [w for w in filtered_words if w.lower() not in custom_stop_words]
no_stop_words_count = Counter(no_stop_words)
filtered_no_stop_words = list()
for element in no_stop_words_count.elements():
	if no_stop_words_count[element] > 5:
		filtered_no_stop_words.append(element)
	#print no_stop_words_count
	#print dict(no_stop_words_count)
	#print(json.dumps(dict(no_stop_words_count)))

	#print list(no_stop_words_count)
	#print no_stop_words_count
filtered_no_stop_words_count = Counter(filtered_no_stop_words)
print filtered_no_stop_words_count.most_common(10)
top_25 = filtered_no_stop_words_count.most_common(25)
	#print filtered_no_stop_words_count
	#print json.dumps(filtered_no_stop_words_count)

output_dir = output_root_dir + "/" + input_dir
try:
	os.makedirs(output_dir)
except OSError:
	if os.path.exists(output_dir):
		# We are nearly safe
		pass
	else:
		# There was an error on creation, so make sure we know about it
		raise
path 	= os.path.join(output_dir, "word_counts_top_results.csv")
writer	= csv.writer(open(path, 'w'))
writer.writerow(["word", "value"])
#for item in filtered_no_stop_words_count.items():
for item in top_25:
	print item
	writer.writerow(item)

		
		

	