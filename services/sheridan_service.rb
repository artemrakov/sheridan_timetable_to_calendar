require './models/table'

class SheridanService
  URL_FOR_LOGIN = 'http://mystudentcentre.sheridancollege.ca/'
  URL_FOR_TIMETABLE = 'https://psoft-sa-students.sheridancollege.ca/psc/saprodlb/EMPLOYEE/HRMS/c/SA_LEARNER_SERVICES.SSR_SSENRL_SCHD_W.GBL?Page=SSR_SS_WEEK&Action=A&ExactKeys=Y&EMPLID=991573034&TargetFrameName=None'

  attr_reader :browser

  def initialize(browser = Watir::Browser.new)
    @browser = browser
  end

  def lessons
    login
    extract_lessons
  end

  private

  def login
    browser.goto URL_FOR_LOGIN

    browser.text_field(id: 'IDToken1').set(ENV['USERNAME'])
    browser.text_field(id: 'IDToken2').set(ENV['PASSWORD'])
    browser.input(class: 'Btn1Def').click
  end

  def extract_lessons
    browser.goto URL_FOR_TIMETABLE
    rows = browser.table(class: 'PSLEVEL1GRIDNBO').tbody.trs
    cols = browser.table(class: 'PSLEVEL1GRIDNBO').tbody.tr.ths

    table = Table.new(rows: rows, cols: cols)

    table.lessons
  end
end
