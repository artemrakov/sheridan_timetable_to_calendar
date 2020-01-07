require 'rubygems'
require 'bundler/setup'
require 'webdrivers/chromedriver'
Bundler.require
Dotenv.load
require './models/calendar'
require './services/sheridan_service'
require './services/google_auth'
require './views/cli'
require './controllers/application_controller'

google_auth = GoogleAuth.for_calendar
service = Calendar::CalendarService.new
sheridan = SheridanService.new
view = CLI.new

controller = ApplicationController.new(google_auth, service, sheridan, view)

controller.run
