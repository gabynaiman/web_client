require 'net/http'
require 'logger'
require 'json'

require 'web_client/version'
require 'web_client/extensions/string'
require 'web_client/request'
require 'web_client/response'
require 'web_client/connection'
require 'web_client/error'

module WebClient

  def self.logger
    @@logger ||= defined?(Rails) ? Rails.logger : Logger.new($stdout)
  end

  def self.logger=(logger)
    @@logger = logger
  end
  
end
