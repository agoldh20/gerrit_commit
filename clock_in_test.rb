require 'rubygems'
require 'mechanize'
require 'figaro'
Figaro.application = Figaro::Application.new(environment: "production", path: "/home/goldwate/Desktop/side_projects/ruby/creds.yml")
Figaro.load

agent = Mechanize.new
page = agent.get('https://workcenter.ad.here.com/psp/ps/?cmd=login')

login_page = page.form('login')

login_page.userid = ENV['here_id']
login_page.pwd = ENV['here_pwd']

workcenter_page = agent.submit(login_page)

time_clock_page = agent.get('https://hr.ad.here.com/psc/hrprod/EMPLOYEE/HRMS/c/TL_EMPLOYEE_FL.TL_RPT_TIME_FLU.GBL?Action=U')

time_clock_form = time_clock_page.form('win0')

dropbox = time_clock_form.search("[@id='TL_RPTD_TIME_PUNCH_TYPE$0']")

pp time_clock_page