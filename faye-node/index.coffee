fs   = require 'fs'
http = require 'http'
faye = require 'faye'
util = require 'util'

httpResponse = (req, res) ->
  fs.readFile './index.html', (error, file) ->
    res.writeHead 200, 'Content-Type': 'text/html'
    res.end file

log = (message...) ->
  console.log "[ECHO]", message


server = http.createServer httpResponse
bayeux = new faye.NodeAdapter({mount: '/faye', timeout: 45})
bayeux.attach(server)
server.listen 8083

bayeux.addExtension(
      incoming: (message, callback) ->
        switch message.channel
          when '/meta/handshake' then log("id: #{message.clientId}; connection;")
          when '/message/disconnect' then log("id: #{message.clientId}; disconnection;")
          when '/message'
            log("id: #{message.clientId}; message: #{message.data};")
            message.data = message.data.toUpperCase();

        console.log("[IN]", message)
        callback(message);

      outgoing: (message, callback) ->
        console.log("[OUT]", message)
        callback(message)
)
