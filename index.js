(function() {
  var Redis, Resque, clients, http, httpResponse, io, listen, listenerConnection, resque, resqueConnection, server, socket;
  http = require('http');
  io = require('socket.io');
  Redis = require("redis");
  Resque = require("resque");
  listenerConnection = Redis.createClient();
  resqueConnection = Redis.createClient();
  resque = Resque.connect({
    redis: resqueConnection
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
  listen = function() {
    return listenerConnection.blpop("resque:MESSAGE", 0, function(err, reply) {
      var client, id, jsonMessage, key, message, _ref;
      key = reply[0], jsonMessage = reply[1];
      _ref = JSON.parse(jsonMessage), id = _ref[0], message = _ref[1];
      console.log("Sending: " + message);
      client = clients[id];
      if (client) {
        client.send(message);
      }
      return process.nextTick(listen);
    });
  };
  listen();
}).call(this);
