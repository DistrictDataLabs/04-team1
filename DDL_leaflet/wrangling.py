#this file just to clean up the csv file


import pandas as pd
import numpy as np

data = pd.read_csv('cinema.csv')
data['location'] = data['location'].apply(lambda x: x.strip())

frequency = data.groupby(['location', 'lat', 'lon']).count()

frequency = pd.DataFrame(frequency).reset_index()
frequency.columns = ['location', 'lat','lon','count']
# print frequency
fre = np.array(frequency)
print fre.shape

# newd = {}
# newd['locations'] = []
# newd['lat'] = []
# newd['log'] = []
# newd['count'] = []

loc_count = {}

for row in fre:
    if row[0] not in loc_count:
        loc_count[row[0]] = []
        loc_count[row[0]].append([row[1], row[2], row[3]])
    if row[0] in loc_count:
        loc_count[row[0]].append(row[3])

# print loc_count

d2 = {k: [v[0][:2], sum(v[1:], v[0][-1])] for k, v in loc_count.items()}
d2 = pd.DataFrame(d2).T.reset_index()
d2.columns = ['country', 'lat_log', 'count']
d2['lat'] = [ele[0] for ele in d2['lat_log']]
d2['log'] = [ele[1] for ele in d2['lat_log']]
d2 = d2.drop('lat_log', 1)
d2.to_csv('cinemaLocation.csv')


# from itertools import chain
#
# for key, value in loc_count.iteritems():
#     new = [item for sublist in value for item in sublist]
#     print new


# for idx, val in enumerate(frequency):
#     print(idx, val)
