# source start.sh

coffee -c index.coffee
node index.js &

QUEUE=message INTERVAL=0.25 rake resque:work &