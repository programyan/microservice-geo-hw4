class Api < Grape::API
  format :json
  content_type :json, 'application/json'

  require 'rack/cors'
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: :get
    end
  end

  rescue_from Grape::Exceptions::ValidationErrors do
    error!({ errors: [{ detail: I18n.t(:missing_params, scope: 'api.errors') }] }, 422)
  end

  desc 'Геокодирование' do
    summary 'Эндпоинт получения координат по городу'
    produces ['application/json']
    consumes ['application/json']
  end
  params do
    requires :city, type: String, desc: 'Город'
  end
  post do
    geocode_params = Contracts::GeocodeContract.new.call(declared(params))

    result = Geocoder.geocode(geocode_params.to_h[:city])

    if result
      { data: result }
    else
      error! ErrorSerializer.from_message(I18n.t(:not_found, scope: 'api.errors.geocoding')), 422
    end
  end

  add_swagger_documentation(
    mount_path: '/swagger/docs',
    info: {
      title: 'Ads API',
      description: 'An API for geocoding',
      contact_name: 'Andrew Ageev',
      contact_email: 'ageev86@gmail.com',
      license: 'MIT',
      license_url: "https://opensource.org/licenses/MIT",
    }
  )
end