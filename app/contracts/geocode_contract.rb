module Contracts
  class GeocodeContract < Dry::Validation::Contract
    params do
      required(:city).filled(:str?)
    end
  end
end