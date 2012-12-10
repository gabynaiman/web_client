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

    def code
      @response.code
    end

    def body
      @response.body
    end

  end
end