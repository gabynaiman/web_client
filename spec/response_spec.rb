require 'spec_helper'

describe WebClient::Response do

  it 'Success' do
    response = WebClient::Response.new HttpResponseFactory.ok('OK')

    response.code.should eq '200'
    response.body.should eq 'OK'
    response.type.should be Net::HTTPOK
    response.success?.should be_true
  end

  it 'Not found' do
    response = WebClient::Response.new HttpResponseFactory.not_found

    response.code.should eq '404'
    response.body.should be_nil
    response.type.should be Net::HTTPNotFound
    response.success?.should be_false
  end

end