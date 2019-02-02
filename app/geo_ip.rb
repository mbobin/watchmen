class GeoIP
  Response = Struct.new(:latitude, :longitude, keyword_init: true) do
    def to_geohash
      GeoHash.encode(latitude, longitude) rescue nil
    end
  end

  class << self
    def call(ip)
      response = Ipstack::API.standard(ip, **ip_options)
      Response.new(response)
    end

    private

    def ip_options
      { fields: 'latitude,longitude' }
    end
  end
end
