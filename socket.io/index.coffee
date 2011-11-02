fs        = require 'fs'
http      = require 'http'
socket_io = require 'socket.io'

httpResponse = (req, res) ->
  fs.readFile './index.html', (error, file) ->
    res.writeHead 200, 'Content-Type': 'text/html'
    res.end file

server = http.createServer httpResponse
server.listen 8082

log = (message...) -> console.log "[ECHO]", message

io = socket_io.listen server
io.sockets.on 'connection', (client) ->
  log("id: #{client.id}; connection;")

  client.on 'message', (message) ->
    log("id: #{client.id}; message: #{message};")
    client.send(message.toUpperCase());

  client.on 'disconnect', -> log("id: #{client.id}; disconnection;")
