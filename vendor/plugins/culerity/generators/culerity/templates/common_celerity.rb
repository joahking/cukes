Before do
  @server = Culerity::run_server
  @browser = Culerity::RemoteBrowserProxy.new @server, {:browser => :firefox}
  @host = 'http://localhost'
end

After do
  @browser.close
  @browser.exit
  @server.close
  kill_orfan_jruby
end

When /I press "(.*)"/ do |button|
  @browser.button(:text, button).click
  assert_successful_response
end

When /I follow "(.*)"/ do |link|
  @browser.link(:text, /#{link}/).click
  assert_successful_response
end

When /I fill in "(.*)" for "(.*)"/ do |value, field|
  @browser.text_field(:id, find_label(field).for).set(value)
end

When /I check "(.*)"/ do |field|
  @browser.check_box(:id, find_label(field).for).set(true)
end

When /^I uncheck "(.*)"$/ do |field|
  @browser.check_box(:id, find_label(field).for).set(false)
end

When /I choose "(.*)"/ do |field|
  @browser.radio(:id, find_label(field).for).set(true)
end

When /I go to "(.*)"/ do |path|
  @browser.goto @host + path
  assert_successful_response
end

When "I wait for the AJAX call to finish" do
  @browser.page.getEnclosingWindow().getThreadManager().joinAll(10000)
end


Then /I should see "(.*)"/ do |text|
  @browser.html.should  =~ /#{text}/m
end

Then /I should not see "(.*)"/ do |text|
  @browser.html.should_not  =~ /#{text}/m
end

def find_label(text)
  @browser.label :text, text
end

def assert_successful_response
  status = @browser.page.web_response.status_code
  if(status == 302 || status == 301)
    location = @browser.page.web_response.get_response_header_value('Location')
    puts "Being redirected to #{location}"
    @browser.goto location
  elsif status != 200
    raise "Brower returned Response Code #{@browser.page.web_response.status_code}"
  end
end

# some java processes are remaining in memory
def kill_orfan_jruby
  pid = `cat tmp/pids/celerity_jruby.pid`.gsub(/[^0-9]/,'')
  unless pid.blank?
    # is it the process still alive?
    remained = `ps #{pid} | grep #{pid} | awk '{ print $1 }'`
    unless remained.blank?
      # we are silencing output because of annoying message
      `kill TERM #{pid} &> /dev/null`
      puts "killed orfan jruby process #{pid}"
    end
    `rm tmp/pids/celerity_jruby.pid`
  end
end

# or you prefer the bash version
# #!/bin/bash
# PID=`cat tmp/pids/celerity_jruby.pid`
# if [ -n $PID ]; then
#   # is it the process still alive?
#   REMAINED_PID=`ps $PID | grep $PID | awk '{ print $1 }'`
#   if [ -n $REMAINED_PID ]; then
#     # we are silencing output because of annoying message
#     kill TERM $PID &> /dev/null
#     echo "killed jruby process $PID"
#   fi
# rm tmp/pids/celerity_jruby.pid
# fi
