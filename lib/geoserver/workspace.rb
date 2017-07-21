module GeoServer
  class Workspace
    WORKSPACES_PATH = "/geoserver/rest/workspaces"

    def initialize(server, parameters = {})
      @server = server
      @parameters = parameters
    end

    def parse(json)
      body = JSON.parse(json, symbolize_names: true)
      @parameters = body[:workspace]
    end

    def delete
      response = @server.delete("#{WORKSPACES_PATH}/#{self[:name]}?recurse=true")
      raise ArgumentError, "Delete workspace failed.\n #{response}" if response.code != "200"
    end

    # Save the Workspace to the server, and store the updated response as the
    # new Workspace parameters.
    def save
      response = @server.post(WORKSPACES_PATH, JSON.generate({ "workspace" => @parameters }))
      raise ArgumentError, "Error creating workspace.\n #{response}" if response.code != "201"
      parse(@server.get(response.header["Location"]).body)
      self
    end

    def [](key)
      @parameters[key]
    end
  end
end
