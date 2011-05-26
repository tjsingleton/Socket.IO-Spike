require 'em-redis'

EM.run do
  redis = EventMachine::Protocols::Redis.connect

  recv = lambda do
    redis.brpop "OUT", 0, do |key, message|
      redis.lpush "resque:MESSAGE", message
      recv.call
    end
  end

  recv.call
end