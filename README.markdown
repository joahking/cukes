# Project to test Cucumber running Webrat and Celerity together

The idea is to get Cucumber running features of Webrat together with Celerity. Right now they are running together, only **I need some help getting celerity waiting for Ajax responses**, see error in [gist](http://gist.github.com/68481).

The features directory is set up like recommended in http://wiki.github.com/aslakhellesoy/cucumber/setting-up-selenium

Webrat and Celerity steps are both using (there's still cleaning to do) the same API (the webrat one) so you have common steps in features/step_definitions/webrat_steps.rb and celerity only in features/step_definitions/celerity_steps.rb

# give it a try

$ rake db:migrate

create a pids directory for jruby process handling
$ mkdir tmp/pids -p

start your test server to have celerity requesting resources
$ ruby script/server -p 80 -e test

## run your features

There are Webrat features in features/plain then you run them with:
$ cucumber -p webrat

There are Celerity only features in features/celerity you run them with:
$ cucumber -p celerity

## more details

To do it we have defined two profiles in cucumber.yml:
<pre>
webrat: -r features/support/env.rb -r features/support/webrat.rb -r features/step_definitions/webrat_steps.rb features/plain
celerity: -r features/support/env.rb -r features/support/culerity.rb -r features/step_definitions/culerity_steps.rb features/celerity
</pre>

The latter would allow to define browser indepent setups (by passing options to Celerity.Browser.new) and then run your steps against e.g firefox and IE.

Inside features/support/webrat.rb and celerity.rb the needed setups for each are accomplished.

## JRuby processes remaining in memory:

sometimes you can have jruby processes alive when they should not, kill them:
$ ps aux | grep jruby | awk '{ print $2 }' | xargs kill TERM

# TODO

* get celerity smoothly running and waiting for ajax responses
* have this all clean up, and have culerity generators do the job
* make the culerity objects initialization in a before_all/after_all manner (now are done in before_each/after_all manner)
* Automate rails server starting and stoping
