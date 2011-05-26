# source start.sh

coffee -c index.coffee
node index.js &

QUEUE=message INTERVAL=0.1 rake resque:work &
QUEUE=message INTERVAL=0.1 rake resque:work &
