require 'csv'

module Geocoder
  extend self

  def geocode(city)
    data[city]
  end

  def data
    @data ||= load_data!
  end

  private

  def load_data!
    @data = CSV.read(ENV.fetch('DATA_PATH'), headers: true).inject({}) do |result, row|
      city = row['city']
      lat = row['geo_lat'].to_f
      lon = row['geo_lon'].to_f
      result[city] = { lat: lat, lon: lon }
      result
    end
  end
end
