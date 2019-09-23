require 'rubygems'
require 'bundler/setup'
Bundler.require
Dotenv.load
require './models/table'
require './services/login'

URL_FOR_LOGIN = 'http://mystudentcentre.sheridancollege.ca/'
URL_FOR_TIMETABLE = 'https://psoft-sa-students.sheridancollege.ca/psc/saprodlb/EMPLOYEE/HRMS/c/SA_LEARNER_SERVICES.SSR_SSENRL_SCHD_W.GBL?Page=SSR_SS_WEEK&Action=A&ExactKeys=Y&EMPLID=991573034&TargetFrameName=None'

browser = Watir::Browser.new

browser.goto URL_FOR_LOGIN

login = Login.new(username_id: 'IDToken1', password_id: 'IDToken2', submit: 'Btn1Def')
login.run(browser)

browser.goto URL_FOR_TIMETABLE

rows = browser.table(class: 'PSLEVEL1GRIDNBO').tbody.trs
cols = browser.table(class: 'PSLEVEL1GRIDNBO').tbody.tr.ths

table = Table.new(rows: rows, cols: cols)

p table.lessons
