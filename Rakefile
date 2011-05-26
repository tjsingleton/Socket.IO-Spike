module ReceiveMessageJob
  extend self

  @queue = :message

  def perform(client_id, message)
    Resque.redis.publish client_id, message
  end
end

require 'resque/tasks'
