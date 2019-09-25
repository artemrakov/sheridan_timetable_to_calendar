require 'rubygems'
require 'bundler/setup'
Bundler.require
Dotenv.load
require './models/calendar'
require './services/sheridan_service'
require './services/google_auth'
require './views/cli'

google_auth = GoogleAuth.for_calendar
service = Calendar::CalendarService.new
sheridan = SheridanService.new

cli = CLI.new(google_auth, service, sheridan)
cli.run
