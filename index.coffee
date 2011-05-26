http = require 'http'
io   = require 'socket.io'

Redis  = require "redis"
Resque = require "resque"

PATTERN = "*"


pubsub_connection = Redis.createClient()
resque_connection = Redis.createClient()

resque = Resque.connect({ redis: resque_connection })


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

pubsub_connection.on "pmessage", (pattern, channel, message) ->
  console.log "Sending: #{message}"
  [prefix, id] = channel.split ":"

  client = clients[id]
  client.send(message) if client

pubsub_connection.psubscribe PATTERN

