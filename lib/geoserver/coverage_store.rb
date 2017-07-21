module GeoServer
  class CoverageStore
    attr_reader :path

    def initialize(server, parent_path, parameters = {})
      @server = server
      @parent_path = parent_path
      @path = nil
      @parameters = parameters
    end

    def parse(json)
      body = JSON.parse(json, symbolize_names: true)
      @parameters = body[:coverageStore]
    end

    # Save the Coverage Store to the server, and store the updated response as
    # the new Coverage Store parameters.
    def save
      response = @server.post("#{@parent_path}/coveragestores", JSON.generate({ "coverageStore" => @parameters }))
      raise ArgumentError, "Error creating coverage store.\n #{response}" if response.code != "201"
      @path = response.header["Location"]
      parse(@server.get(@path).body)
      self
    end

    def [](key)
      @parameters[key]
    end
  end
end
