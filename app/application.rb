require 'bundler'
Bundler.require(:default)

require_relative 'config'
require_relative 'geo_ip'
require_relative 'connection_schema'
require_relative 'influx_data_message'
require_relative 'influx_ingester'

class DbContainer
  extend Dry::Container::Mixin
end

DbContainer.register(:influxdb) { InfluxDB::Client.new(Config.database.name, Config.database.credentials.to_h) }
DbContainer.resolve(:influxdb).create_database

configure do
  set :server, :puma
  set :port, 4000
end

post "/api" do
  schema = ConnectionSchema.call(params)
  content_type :json

  if schema.success?
    InfluxIngester.new(params: schema, metric_name: params[:metric_name]).call
    status :created
  else
    status :unprocessable_entity
    body schema.errors.to_json
  end
end
