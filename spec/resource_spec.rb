require 'spec_helper'


describe WebClient::Resource do

  let(:resource) { WebClient::Resource.new(:users, HOST) }

  it 'index' do
    content = '[{"email":"jperez@mail.com","first_name":"Juan","id":1,"last_name":"Perez","organization":"Test"}]'
    stub_request(:get, "http://#{HOST}/users.json").to_return(body: content)

    response = resource.index

    response.should be_a Net::HTTPOK
    data = JSON.parse(response.body)
    data.should be_a Array
    data.first['id'].should_not be_nil
    data.first['first_name'].should_not be_nil
    data.first['last_name'].should_not be_nil
    data.first['email'].should_not be_nil
    data.first['organization'].should_not be_nil
  end

  it 'show' do
    content = '{"email":"jperez@mail.com","first_name":"Juan","id":1,"last_name":"Perez","organization":"Test"}'
    stub_request(:get, "http://#{HOST}/users/1.json").to_return(body: content)

    response = resource.show(1)

    response.should be_a Net::HTTPOK
    data = JSON.parse(response.body)
    data['id'].should_not be_nil
    data['first_name'].should eq 'Juan'
    data['last_name'].should eq 'Perez'
    data['email'].should eq 'jperez@mail.com'
    data['organization'].should eq 'Test'
  end

  it 'create' do
    content = '{"email":"jperez@mail.com","first_name":"Juan","id":1,"last_name":"Perez","organization":"Test"}'
    stub_request(:post, "http://#{HOST}/users.json").to_return(body: content, status: 201)

    params = {
        'user[first_name]' => 'Juan',
        'user[last_name]' => 'Perez',
        'user[email]' => 'jperez@mail.com',
        'user[organization]' => 'Test'
    }
    response = resource.create(params)

    response.should be_a Net::HTTPCreated
    data = JSON.parse(response.body)
    data['id'].should_not be_nil
    data['first_name'].should eq 'Juan'
    data['last_name'].should eq 'Perez'
    data['email'].should eq 'jperez@mail.com'
    data['organization'].should eq 'Test'
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

    response.should be_a Net::HTTPNoContent
    response.body.should be_nil
  end

  it 'destroy' do
    stub_request(:delete, "http://#{HOST}/users/1.json").to_return(status: 204)

    response = resource.destroy(1)

    response.should be_a Net::HTTPNoContent
    response.body.should be_nil
  end
end