module AdsService
  module Api
    def update(id, coordinates)
      connection
        .patch("ads/#{id}", coordinates.to_json)
    end
  end
end