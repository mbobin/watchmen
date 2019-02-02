class InfluxIngester
  attr_reader :params, :metric_name

  def initialize(params:, metric_name: nil)
    @params = params
    @metric_name = metric_name || "geosshattack"
  end

  def call
    message = InfluxDataMessage.new(**params.to_h)
    database.write_point metric_name, message.serialize
  end

  def database
    DbContainer.resolve(:influxdb)
  end
end