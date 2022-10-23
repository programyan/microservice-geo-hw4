connection = Bunny.new.start
channel = connection.create_channel
queue = channel.queue('geocoding', durable: true)

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  payload = JSON(payload, symbolize_names: true)

  result = Geocoder.geocode(payload[:city])

  AdsService::Client.new.update(payload[:id], result) if result

  channel.ack(delivery_info.delivery_tag)
end