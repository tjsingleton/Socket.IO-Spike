(function() {
  var PATTERN, Redis, Resque, clients, http, httpResponse, io, pubsub_connection, resque, resque_connection, server, socket;
  http = require('http');
  io = require('socket.io');
  Redis = require("redis");
  Resque = require("resque");
  PATTERN = "*";
  pubsub_connection = Redis.createClient();
  resque_connection = Redis.createClient();
  resque = Resque.connect({
    redis: resque_connection
  });
  httpResponse = function(req, res) {
    res.writeHead(200, {
      'Content-Type': 'text/html'
    });
    return res.end('<h1>Hello world</h1>');
  };
  server = http.createServer(httpResponse);
  server.listen(8081);
  socket = io.listen(server);
  clients = {};
  socket.on('connection', function(client) {
    clients[client.sessionId] = client;
    return client.on('message', function(message) {
      console.log("Enqueueing: " + message);
      return resque.enqueue("message", "ReceiveMessageJob", client.sessionId, message);
    });
  });
  pubsub_connection.on("pmessage", function(pattern, channel, message) {
    var client, id, prefix, _ref;
    console.log("Sending: " + message);
    _ref = channel.split(":"), prefix = _ref[0], id = _ref[1];
    client = clients[id];
    if (client) {
      return client.send(message);
    }
  });
  pubsub_connection.psubscribe(PATTERN);
}).call(this);
