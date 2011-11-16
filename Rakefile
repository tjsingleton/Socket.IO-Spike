COFFEE = "../node_modules/coffee-script/bin/coffee"

namespace :build do
  desc "build socket-io test"
  task :socketio do
    system "cd socket.io-0.8.6; npm install socket.io@0.8.6"
    system "cd socket.io-0.8.7; npm install socket.io@0.8.7"
  end

  desc "build faye node test"
  task :fayenode do
    system "npm install faye"
  end

  desc "build faye ruby test"
  task :fayeruby do
    system "gem install bundler; bundle install"
  end

  desc "build all"
  task all: [:socketio, :fayenode, :fayeruby] do
    system "npm install coffee-script"
  end
end

