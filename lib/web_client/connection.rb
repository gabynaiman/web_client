module WebClient
  class Connection

    include Net

    def initialize(*args)
      if args.first.is_a? Hash
        options = args[0].inject({}) { |h, i| h[i[0].to_sym] = i[1]; h }
        host = options[:host]
        port = options[:port]
      else
        host = args[0]
        port = args[1]
      end
      @http = HTTP.new(host, port)
    end

    def host
      @http.address
    end

    def port
      @http.port
    end

    def request!(request)
      begin
        WebClient.logger.debug "[WebClient] #{request.type.to_s.upcase} Url: http://#{host}#{(port != 80) ? ":#{port}" : ''}#{request.url} | Body: #{request.body} | Headers: #{request.headers}"
        response = Response.new @http.request(request.to_http)
        WebClient.logger.debug "[WebClient] RESPONSE Status: #{response.code} | Content: #{response.body}"
        if block_given?
          if response.success?
            yield(response)
          else
            WebClient.logger.error "[WebClient] #{response.code} - Unexpected error\n#{response.body}"
            nil
          end
        else
          response
        end
      rescue Timeout::Error,
          Errno::EHOSTUNREACH,
          Errno::EINVAL,
          Errno::ECONNRESET,
          EOFError,
          HTTPBadResponse,
          HTTPHeaderSyntaxError,
          ProtocolError,
          SocketError,
          Errno::ECONNREFUSED => e
        WebClient.logger.error "[WebClient] #{e.class}: #{e.message}\nServer: #{host}:#{port}\nRequest: #{request.to_json}"
        raise Error, e
      end
    end

    def request(request, &block)
      begin
        request!(request, &block)
      rescue WebClient::Error => e
        nil
      end
    end

    Request::TYPES.each do |request_type|
      define_method "#{request_type}!" do |url, options={}, &block|
        request! Request.new(options.merge(type: request_type, url: url)), &block
      end

      define_method request_type do |url, options={}, &block|
        request Request.new(options.merge(type: request_type, url: url)), &block
      end
    end

  end
end