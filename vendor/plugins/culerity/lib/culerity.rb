require File.dirname(__FILE__) + '/culerity/remote_object_proxy'
require File.dirname(__FILE__) + '/culerity/remote_browser_proxy'

module Culerity

  JRUBY_PROCESS = 'celerity_jruby'
  RAILS_TEST_SERVER = 'rails_test_server'

  def self.start_rails_test_server
    pipe = IO.popen("sudo script/server -p 80 -e test > log/test.log", 'r+')
    `echo #{pipe.pid} > tmp/pids/#{RAILS_TEST_SERVER}.pid`
  end

  def self.run_server
    pipe = IO.popen("jruby #{__FILE__}", 'r+')
    `echo #{pipe.pid} > tmp/pids/#{JRUBY_PROCESS}.pid`
    pipe
  end

  def self.kill_rails_test_server
    kill_process RAILS_TEST_SERVER
  end

  def self.kill_orfan_jrub
    kill_process JRUBY_PROCESS
  end

  protected
  # some java processes are remaining in memory when exceptions occur
  def kill_process(process_name)
    pid = `cat tmp/pids/#{process_name}.pid`.gsub(/[^0-9]/,'')
    unless pid.blank?
      # is it the process still alive?
      remained = `ps #{pid} | grep #{pid} | awk '{ print $1 }'`
      unless remained.blank?
        # we are silencing output because of annoying message
        `kill TERM #{pid} &> /dev/null`
        puts "killed orfan jruby process #{pid}"
      end
      `rm tmp/pids/#{process_name}.pid`
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

end

if __FILE__ == $0
  require File.dirname(__FILE__) + '/culerity/celerity_server'
  Culerity::CelerityServer.new STDIN, STDOUT
end
