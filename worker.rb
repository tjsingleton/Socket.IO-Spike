require "yajl"
require "redis"

$redis = Redis.connect()

recv = lambda do
  key, json = $redis.brpop "OUT", 0
  $redis.lpush "resque:MESSAGE", json
  recv.call
end

recv.call