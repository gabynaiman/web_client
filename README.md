# WebClient

[![Build Status](https://travis-ci.org/gabynaiman/web_client.png?branch=master)](https://travis-ci.org/gabynaiman/web_client)

Net::HTTP wrapper easy to use

## Installation

Add this line to your application's Gemfile:

    gem 'web_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install web_client

## Usage

### Connection initialization

    connection = WebClient::Connection.new 'localhost', 3000
    #or
    connection = WebClient::Connection.new host: 'localhost', port: 3000

### Request types

    connection.get '/users'
    connection.get '/users/123', headers: {content_type: 'application/json'}
    connection.post '/users', body: '...'
    connection.put '/users/123', body: '...'
    connection.delete '/users/123'

### Raising request exceptions

    connection.get url #=> nil
    connection.get! url #=> raise WebClient::Error

### Response info

    response = connection.get url
    response.code #=> 200
    response.body #=> '....'
    response.success? #=> true
    response.type #=> Net::HTTPOK

### Success block

    json = connection.get url do |response|
      JSON.parse response.body
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
