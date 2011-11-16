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
      when '/meta/handshake'     then puts "[ECHO] id: #{message["clientId"]}; connection;"
      when '/message/disconnect' then puts "[ECHO] id: #{message["clientId"]}; disconnection;"
      when '/message'            then puts "[ECHO] id: #{message["clientId"]}; message: #{message["data"]};"
    end

    puts "[IN] #{message.inspect}"

    callback.call(message)
  end

  def outgoing(message, callback)
    puts "[OUT] #{message.inspect}"

    callback.call(message)
  end
end

use Faye::RackAdapter, :mount => '/faye',
                       :timeout => 25,
                       :extensions => [
                           UpperCaseEcho.new,
                           ConnectionLogger.new
                       ]

host = ENV["HOSTNAME"] || `hostname`
port = ENV["PORT"]
body = File.read('./shared/faye.html').gsub("{{VER}}", "Ruby").gsub("{{HOST}}", host).gsub("{{PORT}}", port)

run ->(env) { [200, {'Content-Type' => 'text/html'}, [body]] }
