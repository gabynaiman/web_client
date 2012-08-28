require 'net/http'
require 'active_support/all'
require 'logger'

require 'web_client/version'
require 'web_client/error'
require 'web_client/base'
require 'web_client/resource'

module WebClient

  def self.logger
    @@logger ||= Logger.new($stdout)
  end

  def self.logger=(logger)
    @@logger = logger
  end
  
end

