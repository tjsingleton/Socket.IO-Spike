http = require 'http'
io   = require 'socket.io'

Redis  = require "redis"
Resque = require "resque"

listenerConnection = Redis.createClient()
resqueConnection = Redis.createClient()

resque = Resque.connect({ redis: resqueConnection })


httpResponse = (req, res) ->
 res.writeHead 200, 'Content-Type': 'text/html'
 res.end '<h1>Hello world</h1>'

server = http.createServer httpResponse
server.listen 8081

socket = io.listen server


clients = {}

socket.on 'connection', (client) ->
  clients[client.sessionId] = client

  client.on 'message', (message) ->
    console.log "Enqueueing: #{message}"
    resque.enqueue "message", "ReceiveMessageJob", client.sessionId, message

listen = ->
  listenerConnection.blpop "resque:MESSAGE", 0, (err, reply) ->
    [key, jsonMessage] = reply
    [id, message] = JSON.parse(jsonMessage)

    console.log "Sending: #{message}"

    client = clients[id]
    client.send(message) if client

    process.nextTick listen

listen()
