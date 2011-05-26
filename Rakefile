require 'yajl'
require 'resque/tasks'

module ReceiveMessageJob
  extend self

  @queue = :message

  def perform(client_id, message)
    Resque.redis.rpush "MESSAGE", Yajl::Encoder.encode([client_id, message])
  end
end
