module WebClient
  class Base
    include Net

    attr_reader :http

    def initialize(host, port=nil)
      @http = HTTP.new(host, port)
    end

    def get(path='/', data={}, &block)
      request(HTTP::Get, path, data, &block)
    end

    def post(path='/', data={}, &block)
      request(HTTP::Post, path, data, &block)
    end

    def put(path='/', data={}, &block)
      request(HTTP::Put, path, data, &block)
    end

    def delete(path='/', data={}, &block)
      request(HTTP::Delete, path, data, &block)
    end

    private

    def request(method_class, path='/', data=nil)
      begin
        WebClient.logger.debug "[WebClient] #{method_class.to_s.demodulize.upcase} Url: http://#{@http.address}#{(@http.port != 80) ? ":#{@http.port}" : ''}#{path} | Params: #{data}"
        request = method_class.new(path)
        request.set_form_data(data) if data.is_a? Hash
        request.body = data if data.is_a? String
        yield(request, http) if block_given?
        response = http.request(request)
        WebClient.logger.debug "[WebClient] RESPONSE Status: #{response.code} | Content: #{response.body}"
        response
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, HTTPBadResponse, HTTPHeaderSyntaxError, ProtocolError, SocketError, Errno::ECONNREFUSED => e
        WebClient.logger.error "[WebClient] #{e.class}: #{e.message}"
        raise Error, e
      end
    end

  end
end