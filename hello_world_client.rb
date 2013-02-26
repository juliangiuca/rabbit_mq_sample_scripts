


#Client
require 'rubygems'
require 'bunny'
require 'json'

conn = Bunny.new
conn.start

channel = conn.create_channel
exchange = channel.topic("weathr", :auto_delete => true)

guid = (rand() * 1000).floor
message = {
  :message => ARGV[0] || "hello world",
  :guid => guid
}
json_message = JSON.generate(message)

while(true) do
  exchange.publish(json_message, :routing_key => 'server')

  channel.queue("client").bind(exchange, :routing_key => guid).subscribe do |delivery_info, properties, payload|
    puts "The reverse of your message is: #{payload}"
  end

  sleep(1)
end
conn.stop
