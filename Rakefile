COFFEE = "../node_modules/coffee-script/bin/coffee"

namespace :socketio do
  desc "build socket-io test"
  task :build do
    system "cd socket.io-0.8.6; npm install socket.io@0.8.6"
    system "cd socket.io-0.8.7; npm install socket.io@0.8.7"
  end

  desc "start socket-io test"
  task 'start:0.8.6' do
    system "cd socket.io-0.8.6; #{COFFEE} index.coffee"
  end

  task 'start:0.8.7' do
    system "cd socket.io-0.8.7; #{COFFEE} index.coffee"
  end
end

namespace :fayenode do
  desc "build faye node test"
  task :build do
    system "cd faye-node; npm install faye"
  end

  desc "start faye node test"
  task :start do
    system "cd faye-node; #{COFFEE} index.coffee"
  end
end

namespace :fayeruby do
  desc "build faye ruby test"
  task :build do
    system "gem install thin faye"
  end

  desc "start faye ruby test"
  task :start do
    system "cd faye-ruby; rackup config.ru -s thin -E production"
  end
end

namespace :all do
  desc "build all tests"
  task :build => ["socketio:build", "fayenode:build", "fayeruby:build"] do
    system "npm install coffee-script"
  end
end
