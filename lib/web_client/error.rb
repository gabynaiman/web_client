module WebClient

  class Error < StandardError
    def initialize(inner_error)
      @inner_error = inner_error
    end

    def type
      @inner_error.class
    end

    def message
      @inner_error.message
    end
  end

end