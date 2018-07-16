require 'rubygems'
require 'mechanize'
require 'figaro'
Figaro.application = Figaro::Application.new(environment: "production", path: "/home/goldwate/Desktop/side_projects/ruby/time_clock_test/creds.yml")
Figaro.load

class TimeClock
  attr_accessor :clock_type_input
  
  def clock_type
    puts "Are you clocking In or Out? (i/o)"
    @clock_type_input = gets.chomp
    scrape
  end

  def scrape
    agent = Mechanize.new
    page = agent.get('https://workcenter.ad.here.com/psp/ps/?cmd=login')

    login_page = page.form('login')

    login_page.userid = ENV['here_id']
    login_page.pwd = ENV['here_pwd']

    workcenter_page = agent.submit(login_page)

    time_clock_page = agent.get('https://hr.ad.here.com/psc/hrprod/EMPLOYEE/HRMS/c/TL_EMPLOYEE_FL.TL_RPT_TIME_FLU.GBL?Action=U')

    time_clock_form = time_clock_page.form('win0')

    dropdown = time_clock_form.search("[@id='TL_RPTD_TIME_PUNCH_TYPE$0']")

    @blank = dropdown.search("[@value='']")
    @clock_in = dropdown.search("[@value='1']")
    @clock_out = dropdown.search("[@value='2']")

    @blank.remove_attribute('selected')

    if @clock_type_input == "i"
      clock_in_method
    elsif @clock_type_input == "o"
      clock_out_method
    else
      puts "Invalid Response, Please choos 'i' or 'o'"
      clock_type
    end

    puts "Blank: #{@blank.attr('selected')}\nCLock In: #{@clock_in.attr('selected')}\nClock Out: #{@clock_out.attr('selected')}"
        
    # clock_submit = time_clock_page.at("#TL_WEB_CLOCK_WK_TL_SAVE_PB")

    # p clock_submit.attr('href').click

    # agent.click(clock_submit)
  end

  def clock_in_method
    @clock_in.at('option')['selected'] = 'selected'
  end

  def clock_out_method
    @clock_out.at('option')['selected'] = 'selected'
  end
end

run = TimeClock.new

run.clock_type