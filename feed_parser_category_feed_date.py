import sys
import os
import json
import newspaper

input_file 		= sys.argv[1]
output_root_dir	= sys.argv[2]
	
from newspaper import Article

json_data = []
file = open(input_file, 'r')
try:
	for line in file:
		print line
		json_data.append(json.loads(line))
except:
	pass
file.close()

for i, json_val in enumerate(json_data):
		print i
		print json_val['value'].get('category')
		category = json_val['value'].get('category')
		print json_val['value'].get('title')
		feed = json_val['value'].get('title')
		output_dir = output_root_dir + '/' + category + '/' + feed
		try:
			os.makedirs(output_dir)
		except OSError:
			pass # already exists
			
		#get all the urls
		feeds = json_val['value'].get('feeds')
		for j, a_feed in enumerate(feeds):
			print j
			pubdate = a_feed.get('pubdate')
			dateList = pubdate.values()
			date =  dateList[0]
			print str(i) + " : " + date[0:10]
			date_string = date[0:10]
			link = a_feed.get('url')
			print a_feed.get('postsTitle')
			title = a_feed.get('postsTitle')
			title = title.encode('ascii', 'ignore')
			title = title.strip()

			feed_url = Article(url=link, language='en')
			
			try:
				#download the content
				feed_url.download()

				#parse the html into text form
				feed_url.parse()

				#get the text from the url and clean up
				text = feed_url.text
				text = text.encode('ascii', 'ignore')
				text = text.strip()

				path 		= os.path.join(output_dir, title + '_' + date_string + '.txt')
				output_file = open(path,'w')
				output_file.write(text)
			except:
				pass

	




