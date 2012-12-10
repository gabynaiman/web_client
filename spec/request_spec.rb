require 'spec_helper'

describe WebClient::Request do

  context 'Initialization' do

    it 'with url' do
      request = WebClient::Request.new url: '/'

      request.type.should eq :get
      request.url.should eq '/'
      request.body.should be_nil
      request.headers.should eq Hash.new
    end

    it 'with type' do
      request = WebClient::Request.new url: '/', type: :post

      request.type.should eq :post
      request.url.should eq '/'
      request.body.should be_nil
      request.headers.should eq Hash.new
    end

    it 'with body' do
      request = WebClient::Request.new url: '/', body: 'content'

      request.type.should eq :get
      request.url.should eq '/'
      request.body.should eq 'content'
      request.headers.should eq Hash.new
    end

    it 'with headers' do
      request = WebClient::Request.new url: '/', headers: {content_type: 'application/json'}

      request.type.should eq :get
      request.url.should eq '/'
      request.body.should be_nil
      request.headers.should eq content_type: 'application/json'
    end

    it 'with block' do
      request = WebClient::Request.new do |r|
        r.type = :post
        r.url = '/'
      end

      request.type.should eq :post
      request.url.should eq '/'
      request.body.should be_nil
      request.headers.should eq Hash.new
    end

  end

  context 'Constructors helpers' do

    WebClient::Request::TYPES.each do |request_type|
      it request_type do
        request = WebClient::Request.send request_type, url: '/'

        request.type.should eq request_type
        request.url.should eq '/'
        request.body.should be_nil
        request.headers.should eq Hash.new
      end
    end

  end

end