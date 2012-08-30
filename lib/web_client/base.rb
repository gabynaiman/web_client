module WebClient
  class Base
    include Net

    attr_reader :http

    def initialize(*args)
      if args.first.is_a? Hash
        host = args[0]['host'] || args[0][:host]
        port = args[0]['port'] || args[0][:port]
      else
        host = args[0]
        port = args[1]
      end
      @http = HTTP.new(host, port)
    end

    WebClient::HTTP_METHODS.each do |http_method|
      define_method http_method.to_s.demodulize.downcase do |path='/', data={}, &block|
        request(http_method, path, data, &block)
      end

      define_method "#{http_method.to_s.demodulize.downcase}!" do |path='/', data={}, &block|
        request!(http_method, path, data, &block)
      end
    end

    private

    def request(method_class, path='/', data=nil)
      begin
        response = request!(method_class, path, data)
        response.is_a?(Net::HTTPSuccess) ? response : nil
      rescue WebClient::Error
        nil
      end
    end

    def request!(method_class, path='/', data=nil)
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