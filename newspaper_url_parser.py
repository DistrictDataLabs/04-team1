import sys
import os
import newspaper

input_file 	= sys.argv[1]
output_dir	= 'output'

try:
	os.makedirs(output_dir)
except OSError:
	pass # already exists
	
from newspaper import Article

file = open(input_file, 'r')
try:
	for line in file:
		print line
		feed_url = Article(url=line, language='en')
		

		#download the content
		feed_url.download()

		#parse the html into text form
		feed_url.parse()

		text = feed_url.text
		text = text.encode('ascii', 'ignore')
		text.strip()

		title		= feed_url.title
		title		= title.encode('ascii', 'ignore')
		title		= title.strip()
		path 		= os.path.join(output_dir, title + '.txt')
		output_file = open(path,'w')
		output_file.write(text)
except:
	pass #ignore url parsing errors
	
file.close()



