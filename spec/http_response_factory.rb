module HttpResponseFactory

  def self.ok(body)
    response = Net::HTTPOK.new '1.1', '200', 'nil'
    response.instance_variable_set '@body', body
    response.instance_variable_set '@read', true
    response
  end

  def self.not_found
    response = Net::HTTPNotFound.new '1.1', '404', 'nil'
    response.instance_variable_set '@body', nil
    response.instance_variable_set '@read', true
    response
  end

end