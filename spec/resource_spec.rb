require 'spec_helper'


describe WebClient::Resource do

  let(:resource) { WebClient::Resource.new(:users, HOST) }

  it 'index' do
    content = '[{"id":1,"email":"jperez@mail.com","first_name":"Juan","last_name":"Perez","organization":"Test"}]'
    stub_request(:get, "http://#{HOST}/users.json").to_return(body: content)

    response = resource.index

    response.should be_a Array
    response[0]['id'].should eq 1
    response[0]['email'].should eq 'jperez@mail.com'
    response[0]['first_name'].should eq 'Juan'
    response[0]['last_name'].should eq 'Perez'
    response[0]['organization'].should eq 'Test'
  end

  it 'show' do
    content = '{"id":1,"email":"jperez@mail.com","first_name":"Juan","last_name":"Perez","organization":"Test"}'
    stub_request(:get, "http://#{HOST}/users/1.json").to_return(body: content)

    response = resource.show(1)

    response.should be_a Hash
    response['id'].should eq 1
    response['email'].should eq 'jperez@mail.com'
    response['first_name'].should eq 'Juan'
    response['last_name'].should eq 'Perez'
    response['organization'].should eq 'Test'
  end

  it 'create' do
    content = '{"id":1,"email":"jperez@mail.com","first_name":"Juan","last_name":"Perez","organization":"Test"}'
    stub_request(:post, "http://#{HOST}/users.json").to_return(body: content, status: 201)

    params = {
        'user[first_name]' => 'Juan',
        'user[last_name]' => 'Perez',
        'user[email]' => 'jperez@mail.com',
        'user[organization]' => 'Test'
    }
    response = resource.create(params)

    response.should be_a Hash
    response['id'].should eq 1
    response['email'].should eq 'jperez@mail.com'
    response['first_name'].should eq 'Juan'
    response['last_name'].should eq 'Perez'
    response['organization'].should eq 'Test'
  end

  it 'update' do
    stub_request(:put, "http://#{HOST}/users/1.json").to_return(status: 204)

    params = {
        'user[first_name]' => 'Juan',
        'user[last_name]' => 'Perez',
        'user[email]' => 'jperez@mail.com',
        'user[organization]' => 'Test'
    }
    response = resource.update(1, params)

    response.should be_a Hash
    response.should be_empty
  end

  it 'destroy' do
    stub_request(:delete, "http://#{HOST}/users/1.json").to_return(status: 204)

    response = resource.destroy(1)

    response.should be_a Hash
    response.should be_empty
  end
end