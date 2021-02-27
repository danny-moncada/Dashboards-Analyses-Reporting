#this function is designed to work for east coast dates. It converts the date to the correct one for IQL queries
def convert_date(date_to_convert):
    try:
        if str(pd.to_datetime(date_to_convert).tz_localize('US/Eastern').tz_convert('US/Central'))[-4] == '5':
            return pd.to_datetime(date_to_convert).tz_localize('US/Eastern').tz_convert('US/Central').strftime('%Y-%m-%d 23:00:00')
        else:
            return pd.to_datetime(date_to_convert).strftime('%Y-%m-%d')
    except:
        return date_to_convert