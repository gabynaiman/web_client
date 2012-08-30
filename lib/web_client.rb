require 'net/http'
require 'active_support/all'
require 'logger'
require 'json'

module WebClient
  HTTP_METHODS = [Net::HTTP::Get, Net::HTTP::Post, Net::HTTP::Put, Net::HTTP::Delete].freeze

  def self.logger
    @@logger ||= defined?(Rails) ? Rails.logger : Logger.new($stdout)
  end

  def self.logger=(logger)
    @@logger = logger
  end
  
end

require 'web_client/version'
require 'web_client/error'
require 'web_client/base'
require 'web_client/resource'
