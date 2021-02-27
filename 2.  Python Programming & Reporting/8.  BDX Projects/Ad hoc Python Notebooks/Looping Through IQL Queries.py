import iql

#if we want to grab revenue for 3 different time periods:
time_ranges = [['2016-01-01','2016-02-01'],
			   ['2016-01-01','2016-02-01'],
			   ['2016-01-01','2016-02-01']]

#this is the dictionary that will store all of the dataframes
output_dictionary = {}

for time in time_frames:
	
	query = 'from adcrev {} {} select cost/100'.format(time[0],time[1])
	
	#run the query, with the output being stored to the dictionary and the key being the first month
	#time[0][6] is slices out the Month number from the first date in 'time'
	output_dictionary[time[0][6]] = iql.dataframe(query)