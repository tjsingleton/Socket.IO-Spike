socket_ver  = process.argv[2]
port      = process.env.PORT
host      = process.env.HOSTNAME || `hostname`

console.log "socket.io #{socket_ver} started on http://#{host}:#{port}"

fs        = require 'fs'
http      = require 'http'
socket_io = require "../socket.io-#{socket_ver}/node_modules/socket.io"

httpResponse = (req, res) ->
  fs.readFile './shared/socket-io.html', (error, file) ->
    res.writeHead 200, 'Content-Type': 'text/html'
    file = file.toString()
    file = file.replace(/\{\{VER\}\}/g, socket_ver)
    file = file.replace(/\{\{PORT\}\}/g, port)
    file = file.replace(/\{\{HOST\}\}/g, host)
    res.end file

server = http.createServer httpResponse
server.listen port 

log = (message...) -> console.log "[ECHO]", message

io = socket_io.listen server
io.sockets.on 'connection', (client) ->
  log("id: #{client.id}; connection;")

  client.on 'message', (message) ->
    log("id: #{client.id}; message: #{message};")
    client.send(message.toUpperCase())

  client.on 'disconnect', -> log("id: #{client.id}; disconnection;")

