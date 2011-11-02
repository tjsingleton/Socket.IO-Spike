require 'faye'

class UpperCaseEcho
  def incoming(message, callback)
    if message["channel"] == "/message"
      message["data"].upcase!
    end

    callback.call(message)
  end
end

class ConnectionLogger
  def incoming(message, callback)
    case message['channel']
      when '/meta/handshake'     then puts "id: #{message["clientId"]}; connection;"
      when '/message/disconnect' then puts "id: #{message["clientId"]}; disconnection;"
      when '/message'            then puts "id: #{message["clientId"]}; message: #{message["data"]};"
    end

    callback.call(message)
  end

  def outgoing(message, callback)
    callback.call(message)
  end
end

use Faye::RackAdapter, :mount => '/faye',
                       :timeout => 25,
                       :extensions => [
                           UpperCaseEcho.new,
                           ConnectionLogger.new
                       ]

body = File.read('index.html')
app  = lambda {|env| [200, {'Content-Type' => 'text/html'}, [body]] }
run app
