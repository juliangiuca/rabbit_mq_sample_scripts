


#Server
require 'rubygems'
require 'bunny'
require 'json'

conn = Bunny.new
conn.start

channel = conn.create_channel
exchange = channel.topic("weathr", :auto_delete => true)

channel.queue("server").bind(exchange, :routing_key => "server.#").subscribe(:block => true) do |delivery_info, properties, payload|
  my_message = JSON.parse(payload)
  guid = my_message["guid"]
  puts "Received #{my_message["message"]}"

  exchange.publish(my_message["message"].reverse + " with the guid of " + guid.to_s, :routing_key => guid)
end

conn.stop
