module WebClient
  class JSON

    def initialize(*args)
      @http_client = Base.new(*args)
    end

    WebClient::HTTP_METHODS.each do |http_method|
      method_name = http_method.to_s.demodulize.downcase
      define_method method_name do |*args, &block|
        response = @http_client.send(method_name, *args, &block)
        response ? ::JSON.parse(response.body || '{}') : nil
      end
    end

  end
end