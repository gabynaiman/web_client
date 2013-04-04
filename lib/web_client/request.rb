module WebClient
  class Request

    TYPES = [:get, :post, :put, :delete]

    attr_accessor :type
    attr_accessor :url
    attr_accessor :body
    attr_accessor :headers

    def initialize(options={}, &block)
      @type = options[:type] || :get
      @url = options[:url]
      @body = options[:body]
      @headers = options[:headers] || {}

      block.call(self) if block_given?
    end

    def to_http
      klass = eval("Net::HTTP::#{type.to_s.capitalize}")
      request = klass.new url
      request.set_form_data(body) if body.is_a? Hash
      request.body = body if body.is_a? String
      headers.each { |k, v| request.send("#{k}=", v) }
      request
    end

    TYPES.each do |request_type|
      define_singleton_method request_type do |options, &block|
        new options.merge(type: request_type, &block)
      end
    end
    
  end
end