class InfluxDataMessage
  attr_reader :ip, :port, :username

  def initialize(ip:, port:, username:)
    @ip = ip
    @port = port
    @username = username
  end

  def geohash
    geo_ip.to_geohash 
  end

  def geo_ip
    @geo_ip ||= GeoIP.call(ip)
  end

  def serialize
    {
      values: {
        value: 1,
      },
      tags: {
        geohash: geohash,
        username: username,
        port: port,
        ip: ip,
      }
    }
  end
end