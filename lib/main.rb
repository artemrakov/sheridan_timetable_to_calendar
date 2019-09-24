require 'rubygems'
require 'bundler/setup'
Bundler.require
Dotenv.load
require './models/table'
require './services/login'
require './services/google_credentials'

# URL_FOR_LOGIN = 'http://mystudentcentre.sheridancollege.ca/'
# URL_FOR_TIMETABLE = 'https://psoft-sa-students.sheridancollege.ca/psc/saprodlb/EMPLOYEE/HRMS/c/SA_LEARNER_SERVICES.SSR_SSENRL_SCHD_W.GBL?Page=SSR_SS_WEEK&Action=A&ExactKeys=Y&EMPLID=991573034&TargetFrameName=None'

# browser = Watir::Browser.new

# browser.goto URL_FOR_LOGIN

# login = Login.new(username_id: 'IDToken1', password_id: 'IDToken2', submit: 'Btn1Def')
# login.run(browser)

# browser.goto URL_FOR_TIMETABLE

# rows = browser.table(class: 'PSLEVEL1GRIDNBO').tbody.trs
# cols = browser.table(class: 'PSLEVEL1GRIDNBO').tbody.tr.ths

# table = Table.new(rows: rows, cols: cols)

# lessons = table.lessons
engine = GoogleCredentials.for_calendar

# Auth GOOGLE dont need if you have refresh token
# puts "go to #{engine.authorization_url}"
# puts 'paste in the authorization code'
# auth_code = gets.strip
# refresh_token = engine.renew_refresh_token(auth_code)
# engine.save_refresh_token(refresh_token)

auth_client = engine.load_user_refresh_credentials
p auth_client
calendar = Google::Apis::CalendarV3::CalendarService.new
calendar.authorization = auth_client

response = calendar.list_events('primary',
                               max_results:   10,
                               single_events: true,
                               order_by:      "startTime",
                               time_min:      DateTime.now.rfc3339)
p response
