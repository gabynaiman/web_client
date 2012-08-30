require 'spec_helper'

describe WebClient::Base do

  let(:client) { WebClient::Base.new(HOST) }

  context 'HTTP methods' do

    it 'get' do
      stub_request(:get, "#{HOST}/get_stub").to_return(body: 'content')
      response = client.get('/get_stub')
      response.should be_a Net::HTTPOK
      response.body.should eq 'content'
    end

    it 'post' do
      stub_request(:post, "#{HOST}/post_stub").with(body: 'form_data')
      response = client.post('/post_stub', 'form_data')
      response.should be_a Net::HTTPOK
      response.body.should be_nil
    end

    it 'put' do
      stub_request(:put, "#{HOST}/put_stub").with(body: 'form_data')
      response = client.put('/put_stub', 'form_data')
      response.should be_a Net::HTTPOK
      response.body.should be_nil
    end

    it 'delete' do
      stub_request(:delete, "#{HOST}/delete_stub").with(body: 'form_data')
      response = client.delete('/delete_stub', 'form_data')
      response.should be_a Net::HTTPOK
      response.body.should be_nil
    end

  end

  context 'Actions with a block' do

    it 'get' do
      stub_request(:get, /.*/)
      client.get('/get_stub') do |request, http|
        request.path.should eq '/get_stub'
        http.address.should eq HOST
      end
    end

    it 'post' do
      stub_request(:post, /.*/)
      client.post('/post_stub', {}) do |request, http|
        request.path.should eq '/post_stub'
        http.address.should eq HOST
      end
    end

    it 'put' do
      stub_request(:put, /.*/)
      client.put('/put_stub', {}) do |request, http|
        request.path.should eq '/put_stub'
        http.address.should eq HOST
      end
    end

    it 'delete' do
      stub_request(:delete, /.*/)
      client.delete('/delete_stub') do |request, http|
        request.path.should eq '/delete_stub'
        http.address.should eq HOST
      end
    end

  end

  context 'Errors handling' do

    it 'Invalid host exception' do
      stub_request(:get, /.*/).to_raise(SocketError.new('getaddrinfo: No such host is known.'))
      lambda { client.get }.should raise_error WebClient::Error
    end

    it 'Timeout exception' do
      stub_request(:get, /.*/).to_timeout
      lambda { client.get }.should raise_error WebClient::Error
    end

  end

end