module WebClient

  class Error < StandardError
    def initialize(inner_error)
      @inner_error = inner_error
    end

    def type
      @inner_error.class
    end

    def message
      "#{type}: #{@inner_error.message}"
    end

    def to_s
      message
    end
  end

end