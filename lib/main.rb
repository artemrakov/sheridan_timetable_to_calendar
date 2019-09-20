require 'rubygems'
require 'bundler/setup'
require_relative 'table'
Bundler.require
Dotenv.load

URL_FOR_TIMETABLE = 'https://psoft-sa-students.sheridancollege.ca/psc/saprodlb/EMPLOYEE/HRMS/c/SA_LEARNER_SERVICES.SSR_SSENRL_SCHD_W.GBL?Page=SSR_SS_WEEK&Action=A&ExactKeys=Y&EMPLID=991573034&TargetFrameName=None'

browser = Watir::Browser.new

browser.goto('http://mystudentcentre.sheridancollege.ca/')

# log_in
browser.text_field(id: 'IDToken1').set(ENV['USERNAME'])
browser.text_field(id: 'IDToken2').set(ENV['PASSWORD'])
browser.input(class: 'Btn1Def').click

browser.goto URL_FOR_TIMETABLE

rows = browser.table(class: 'PSLEVEL1GRIDNBO').tbody.trs
cols = browser.table(class: 'PSLEVEL1GRIDNBO').tbody.tr.ths
table = Table.new(rows: rows, cols: cols)

p table.dates
