require File.expand_path '../spec_helper.rb', __FILE__

describe "Application" do
  context 'without params' do
    before do
      post '/api'
    end

    it { expect(last_response).to be_unprocessable }
    it { expect(last_response.content_type).to include("json") }
    it { expect(last_response.body).to include("is missing") }
  end

  context 'with params' do
    before do
      stub_request(:get, /http:\/\/api\.ipstack\.com\/.*/).
        to_return(status: 200, body: '{ "longitude": 1, "latitude": 1 }', headers: {})

      stub_request(:post, /.*/).
        with(
          body: "geosshattack,geohash=s00twy01mtw0,username=bob,port=22,ip=37.235.1.174 value=1i",
          ).
        to_return(status: 204, body: "", headers: {})
    end

    before do
      post '/api', { ip: '37.235.1.174', username: 'bob', port: 22 }
    end

    it { expect(last_response).to be_created }
    it { expect(last_response.content_type).to include("json") }
    it { expect(last_response.body).to be_empty }
  end

  context 'with metric name' do
    before do
      stub_request(:get, /http:\/\/api\.ipstack\.com\/.*/).
        to_return(status: 200, body: '{ "longitude": 1, "latitude": 1 }', headers: {})

      stub_request(:post, /.*/).
        with(
          body: "attack,geohash=s00twy01mtw0,username=bob,port=22,ip=37.235.1.174 value=1i",
          ).
        to_return(status: 204, body: "", headers: {})
    end

    before do
      post '/api', { ip: '37.235.1.174', username: 'bob', port: 22, metric_name: 'attack' }
    end

    it { expect(last_response).to be_created }
    it { expect(last_response.content_type).to include("json") }
    it { expect(last_response.body).to be_empty }
  end
end
