# culerity setup (this will be generated for you)
# right now the before runs before every step
Before do
  # start_rails_test_server
  @server ||= Culerity::run_server
  # the resynchronize option is recommended in celerity but does not run,
  # firefox one is self explanatory
  @browser ||= Culerity::RemoteBrowserProxy.new(@server,
                                                { :browser => :firefox,
                                                  :resynchronize => true })
  @host ||= 'http://localhost'
end

# we are mixing a Before every step hook with an after_all one, I don't get any
# World do variant to run
at_exit do
  unless @browser.nil?
    @browser.close
    @browser.exit
    @server.close
  end
  kill_orfan_jruby
#   kill_rails_test_server
end

# some java processes are remaining in memory when exceptions occur
def kill_orfan_jruby
  pid = `cat tmp/pids/celerity_jruby.pid`.gsub(/[^0-9]/,'')
  unless pid.blank?
    # is it the process still alive?
    remained = `ps #{pid} | grep #{pid} | awk '{ print $1 }'`
    unless remained.blank?
      # we are silencing output because of annoying message
      `kill TERM #{pid} &> /dev/null`
      puts "killed jruby process with pid #{pid}"
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
