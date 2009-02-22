require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

# now we are rewriting the steps to follow same API as webrat
# and defining visit and click_link methods down bellow
#TODO dry out common steps with webrat
When /^I go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /I follow "(.*)"/ do |link|
  click_link(link)
end

# this here have no webrat counterpart so would belong into culerity only steps
When "I wait for the AJAX call to finish" do
  @browser.page.getEnclosingWindow().getThreadManager().joinAll(10000)
end

Then /I should see "(.*)"/ do |text|
  @browser.html.should  =~ /#{text}/m
end

# and these are the methods to comply with webrat API
#TODO move them out of steps and into some sort of unique internal implemmentation
def visit(path)
  @browser.goto full_url(path)
  assert_successful_response
end

def click_link(link)
  @browser.link(:text, /#{link}/).click
  # neither
  @browser.wait # recommended in celerity github wiki
  # nor
#   And "I wait for the AJAX call to finish"
  # solve the problem, no ajax response is comming back
  assert_successful_response
end

# this here are celerity support
def full_url(path)
  "#{@host}#{path}"
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
