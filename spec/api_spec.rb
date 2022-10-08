# frozen_string_literal: true

require 'spec_helper'

describe Api, :aggregate_failures do
  include Rack::Test::Methods

  def app
    Api
  end

  let(:city) { 'City 17' }

  describe 'POST /' do
    context 'without city' do
      before { post '/' }

      it 'returns error' do
        expect(last_response.status).to eq(422)
        expect(JSON.parse(last_response.body)['errors']).to include('detail' => I18n.t!('api.errors.missing_params'))
      end
    end

    context 'with city' do
      before { post "/", { city: city } }

      context 'and it is invalid' do
        let(:city) { 'invalid' }

        it 'returns error' do
          expect(last_response.status).to eq(422)
          expect(JSON.parse(last_response.body)['errors']).to include('detail' => I18n.t!('api.errors.geocoding.not_found'))
        end
      end

      context 'and it is valid' do
        it 'returns coordinates' do
          expect(last_response.status).to eq(201)
          expect(JSON.parse(last_response.body)['data']).to eq({ 'lat' => 45.05, 'lon' => 90.05 })
        end
      end
    end
  end

  describe 'Swagger Documentation' do
    before { get '/swagger/docs' }

    it { expect(last_response.status).to eq 200 }
  end
end