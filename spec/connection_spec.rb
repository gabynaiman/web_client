require 'spec_helper'

describe WebClient::Connection do

  let(:connection) { WebClient::Connection.new(HOST) }

  context 'Constructor' do

    it 'with host' do
      connection = WebClient::Connection.new 'localhost'

      connection.host.should eq 'localhost'
      connection.port.should eq 80
    end

    it 'with host and port' do
      connection = WebClient::Connection.new 'localhost', 1234

      connection.host.should eq 'localhost'
      connection.port.should eq 1234
    end

    it 'with option host' do
      connection = WebClient::Connection.new host: 'localhost'

      connection.host.should eq 'localhost'
      connection.port.should eq 80
    end

    it 'with options host and port' do
      connection = WebClient::Connection.new host: 'localhost', port: 1234

      connection.host.should eq 'localhost'
      connection.port.should eq 1234
    end

  end

  context 'Request type helpers' do

    it 'get' do
      stub_request(:get, "#{HOST}/get_stub").to_return(body: 'content')
      response = connection.get('/get_stub')

      response.type.should be Net::HTTPOK
      response.body.should eq 'content'
    end

    it 'post' do
      stub_request(:post, "#{HOST}/post_stub").with(body: 'form_data')
      response = connection.post('/post_stub', body: 'form_data')

      response.type.should be Net::HTTPOK
      response.body.should be_nil
    end

    it 'put' do
      stub_request(:put, "#{HOST}/put_stub").with(body: 'form_data')
      response = connection.put('/put_stub', body: 'form_data')

      response.type.should be Net::HTTPOK
      response.body.should be_nil
    end

    it 'delete' do
      stub_request(:delete, "#{HOST}/delete_stub").with(body: 'form_data')
      response = connection.delete('/delete_stub', body: 'form_data')

      response.type.should be Net::HTTPOK
      response.body.should be_nil
    end

  end

  context 'Actions with headers' do

    it 'get' do
      stub_request(:get, "#{HOST}/get_stub").
          with(headers: {content_type: 'application/json'}).
          to_return(body: 'content')
      response = connection.get('/get_stub', headers: {content_type: 'application/json'})

      response.type.should be Net::HTTPOK
      response.body.should eq 'content'
    end

    it 'post' do
      stub_request(:post, "#{HOST}/post_stub").
          with(headers: {content_type: 'application/json'}).
          with(body: 'form_data')
      response = connection.post('/post_stub', body: 'form_data', headers: {content_type: 'application/json'})

      response.type.should be Net::HTTPOK
      response.body.should be_nil
    end

    it 'put' do
      stub_request(:put, "#{HOST}/put_stub").
          with(headers: {content_type: 'application/json'}).
          with(body: 'form_data')
      response = connection.put('/put_stub', body: 'form_data', headers: {content_type: 'application/json'})

      response.type.should be Net::HTTPOK
      response.body.should be_nil
    end

    it 'delete' do
      stub_request(:delete, "#{HOST}/delete_stub").
          with(headers: {content_type: 'application/json'}).
          with(body: 'form_data')
      response = connection.delete('/delete_stub', body: 'form_data', headers: {content_type: 'application/json'})

      response.type.should be Net::HTTPOK
      response.body.should be_nil
    end

  end

  context 'Errors handling' do

    it 'Invalid host exception' do
      stub_request(:get, /.*/).to_raise(SocketError.new('getaddrinfo: No such host is known.'))
      expect { connection.get! '/' }.to raise_error WebClient::Error
    end

    it 'Timeout exception' do
      stub_request(:get, /.*/).to_timeout
      expect { connection.get! '/' }.to raise_error WebClient::Error
    end

  end

  context 'Safe mode' do

    it 'Success response' do
      stub_request(:get, "#{HOST}/get_stub").to_return(body: '{"id":1,"name":"John"}')
      json = connection.get('/get_stub') do |response|
        JSON.parse response.body
      end

      json.should eq 'id' => 1, 'name' => 'John'
    end

    it 'Invalid response' do
      stub_request(:get, "#{HOST}/get_stub").to_return(status: 404)
      json = connection.get('/get_stub') do |response|
        JSON.parse response.body
      end

      json.should be_nil
    end

    it 'Request error' do
      stub_request(:get, "#{HOST}/get_stub").to_timeout
      json = connection.get('/get_stub') do |response|
        JSON.parse response.body
      end

      json.should be_nil
    end

  end

  context 'Unsafe mode' do

    it 'Success response' do
      stub_request(:get, "#{HOST}/get_stub").to_return(body: '{"id":1,"name":"John"}')
      json = connection.get!('/get_stub') do |response|
        JSON.parse response.body
      end

      json.should eq 'id' => 1, 'name' => 'John'
    end

    it 'Invalid response' do
      stub_request(:get, "#{HOST}/get_stub").to_return(status: 404)
      json = connection.get!('/get_stub') do |response|
        JSON.parse response.body
      end

      json.should be_nil
    end

    it 'Request error' do
      stub_request(:get, "#{HOST}/get_stub").to_timeout
      expect { connection.get!('/get_stub') { |r| JSON.parse r.body } }.to raise_error WebClient::Error
    end

  end

end
