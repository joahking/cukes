ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'cucumber/formatters/unicode' # Comment out this line if you don't want Cucumber Unicode support
Cucumber::Rails.use_transactional_fixtures

require 'cucumber/rails/rspec'

require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

# Comment out the next two lines if you're not using RSpec's matchers (should / should_not) in your steps.

require 'webrat/rails'
# webrat 0.4.2 bug http://webrat.lighthouseapp.com/projects/10503/tickets/73-undefined-method-visits
require 'webrat/rspec-rails'
