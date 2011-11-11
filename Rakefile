COFFEE = "../node_modules/coffee-script/bin/coffee"

namespace :build do
  desc "build socket-io test"
  task :socketio do
    system "cd socket.io-0.8.6; npm install socket.io@0.8.6"
    system "cd socket.io-0.8.7; npm install socket.io@0.8.7"
  end

 desc "build faye node test"
  task :fayenode do
    system "cd faye-node; npm install faye"
  end

  desc "build faye ruby test"
  task :fayeruby do
    system "gem install thin faye"
  end
end

namespace :all do
  NSPACES = {
    "faye-node"       => "#{COFFEE} index.coffee",
    "faye-ruby"       => "rackup config.ru -s thin -E production",
    "socket.io-0.8.6" => "#{COFFEE} index.coffee",
    "socket.io-0.8.7" => "#{COFFEE} index.coffee"
  }

  desc "build all tests"
  task :build => ["socketio:build", "fayenode:build", "fayeruby:build"] do
    system "npm install coffee-script"
  end

  desc "start all"
  task :start do
    cmds = NSPACES.map do |name, cmd|
      "cd #{name}; nohup (#{cmd} &> ../log/#{name}.log & echo $! > ../tmp/pids/#{name}); cd .."
    end
    puts cmds.join("; ")
  end

  desc "stop all"
  task :stop do
    cmds = NSPACES.keys.map do |name|
      "kill `cat tmp/pids/#{name}`; rm tmp/pids/#{name}`"
    end

    puts cmds.join("; ")
  end
end

