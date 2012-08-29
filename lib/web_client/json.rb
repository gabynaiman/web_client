module WebClient
  class JSON < Base

    WebClient::HTTP_METHODS.each do |http_method|
      method_name = http_method.to_s.demodulize.downcase
      define_method method_name do |*args, &block|
        response = Base.instance_method(method_name).bind(self).call(*args, &block)
        response ? ::JSON.parse(response.body) : nil
      end
    end

  end
end