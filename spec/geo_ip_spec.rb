require File.expand_path '../spec_helper.rb', __FILE__

describe GeoIP do
  subject(:subject) { described_class.call(ip) }

  before do
    stub_request(:get, /http:\/\/api\.ipstack\.com\/#{ip}\?access_key=(.*?)&fields=latitude,longitude/).
      to_return(status: 200, body: response_body.to_json, headers: {})
  end

  context 'with public ip' do
    let(:ip) { "188.22.33.44" }
    let(:response_body) { { longitude: 1, latitude: 1 } }

    it { is_expected.to be_a(Struct) }

    it { expect(subject.to_geohash).to eq("s00twy01mtw0") }
  end

  context 'with internal ip' do
    let(:ip) { "192.168.0.1" }
    let(:response_body) { { longitude: nil, latitude: nil } }

    it { is_expected.to be_a(Struct) }

    it { expect(subject.to_geohash).to be_nil }
  end
end
