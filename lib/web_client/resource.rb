module WebClient
  class Resource < Base
    attr_reader :resource

    def initialize(resource, *args)
      @resource = resource
      super(*args)
    end

    def index(&block)
      get("/#{resource}.json", &block)
    end

    def show(id, &block)
      get("/#{resource}/#{id}.json", &block)
    end

    def create(data, &block)
      post("/#{resource}.json", data, &block)
    end

    def update(id, data, &block)
      put("/#{resource}/#{id}.json", data, &block)
    end

    def destroy(id, &block)
      delete("/#{resource}/#{id}.json", &block)
    end

  end
end