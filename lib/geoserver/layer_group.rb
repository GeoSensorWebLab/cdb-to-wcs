module GeoServer
  class LayerGroup
    attr_reader :path

    DEFAULT_PARAMETERS = {
    }

    def initialize(server, parent_path, parameters = {})
      @server = server
      @parent_path = parent_path
      @path = nil
      @parameters = DEFAULT_PARAMETERS.merge(parameters)
    end

    def parse(json)
      body = JSON.parse(json, symbolize_names: true)
      @parameters = body[:layerGroup]
    end

    # Save the Layer Group to the server, and store the updated response as
    # the new Layer Group parameters.
    def save
      response = @server.post("#{@parent_path}/layergroups", JSON.generate({ "layerGroup" => @parameters }))
      raise ArgumentError, "Error creating layer group.\n #{response.body}" if response.code != "201"
      @path = response.header["Location"]
      parse(@server.get(@path).body)
      self
    end

    def [](key)
      @parameters[key]
    end
  end
end
