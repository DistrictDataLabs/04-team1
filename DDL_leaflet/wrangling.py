#this file just to clean up the csv file


import pandas as pd

data = pd.read_csv('location_w_latlong.csv')
data['location'] = data['location'].apply(lambda x: x.strip())

frequency = data.groupby(['location', 'lat', 'lon']).count()
frequency = pd.DataFrame(frequency).reset_index()
frequency.columns = ['location', 'lat', 'lon', 'count']
frequency.to_csv('Newslocations.csv')
