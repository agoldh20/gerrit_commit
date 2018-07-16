require 'rubygems'
require 'mechanize'
require 'figaro'
Figaro.application = Figaro::Application.new(environment: "production", path: "/Users/Adam/Desktop/Projects/Ruby/test_clock_in/creds.yml")
Figaro.load

agent = Mechanize.new
page = agent.get('https://workcenter.ad.here.com/psp/ps/?cmd=login')

login_page = page.form('login')

login_page.userid = ENV['here_id']
login_page.pwd = ENV['here_pwd']

workcenter_page = agent.submit(login_page)

time_clock_page = agent.get('https://hr.ad.here.com/psc/hrprod/EMPLOYEE/HRMS/c/TL_EMPLOYEE_FL.TL_RPT_TIME_FLU.GBL?Action=U')

time_clock_form = time_clock_page.form('win0')

dropdown = time_clock_form.search("[@id='TL_RPTD_TIME_PUNCH_TYPE$0']")

clock_in = dropdown.search("[@value='1']")
clock_out = dropdown.search("[@value='2']")

clock_in.at('option')['selected'] = 'selected'
clock_out.at('option')['selected'] = ''


# pp login_page
# puts "======================================"
puts "In: #{clock_in.attr('selected')}"
puts "Out: #{clock_out.attr('selected')}"

agent.submit(time_clock_form)
