require 'bundler/setup'

env = ENV.fetch('RACK_ENV', 'development')

Bundler.require(:default, env)

Dotenv.load(".env.#{env}.local", ".env.#{env}", '.env')

module Loader
  module_function

  def load_all!
    init!
    load_dir('app/**/*.rb')
  end

  def init!
    load_dir('config/initializers/**/*.rb')
  end

  def load_dir(dir)
    Dir[dir].each do |file_name|
      require_relative "../#{file_name}"
    end
  end
end