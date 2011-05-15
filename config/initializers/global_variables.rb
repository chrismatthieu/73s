# Change globals to match the proper value for your site

DELETE_CONFIRM = "Are you sure you want to delete?\nThis can not be undone."
SEARCH_LIMIT = 25
SITE_NAME = '73s.org'

# #SITE = RAILS_ENV == 'production' ? '73s.org' : 'localhost:3000'
## SITE = RAILS_ENV == 'production' ? '73s.org' : '73s.org'
# SITE = RAILS_ENV == 'development' ? '73s.org' : '73s.org'
SITE = RAILS_ENV == 'production' ? '73s.org' : 'localhost:3000'

MAILER_TO_ADDRESS = 'info@#{SITE}'
MAILER_FROM_ADDRESS = '73s.org <n7ice@73s.org>'
REGISTRATION_RECIPIENTS = %W(n7ice@73s.org) #send an email to this list everytime someone signs up


YOUTUBE_BASE_URL = "http://gdata.youtube.com/feeds/api/videos/"