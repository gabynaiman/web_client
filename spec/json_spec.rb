require 'spec_helper'

describe WebClient::JSON do

  let(:client) { WebClient::JSON.new(HOST) }

  %w(get post put delete).each do |http_method|
    it http_method do
      stub_request(http_method.to_sym, "#{HOST}/action.json").to_return(body: '{"id":1,"email":"jperez@mail.com","first_name":"Juan","last_name":"Perez","organization":"Test"}')
      response = client.send(http_method, '/action.json')
      response.should be_a Hash
      response['id'].should eq 1
      response['email'].should eq 'jperez@mail.com'
      response['first_name'].should eq 'Juan'
      response['last_name'].should eq 'Perez'
      response['organization'].should eq 'Test'
    end
  end

end