module WebClient
  class Response

    def initialize(response)
      @response = response
    end

    def type
      @response.class
    end

    def success?
      @response.is_a? Net::HTTPSuccess
    end

    def method_missing(method, *args, &block)
      if @response.respond_to? method
        @response.send method, *args, &block
      else
        super
      end
    end

    def methods
      (super | @response.methods).uniq
    end

    def respond_to?(method)
      super || @response.respond_to?(method)
    end

  end
end