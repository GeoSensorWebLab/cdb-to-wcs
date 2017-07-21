module GeoServer
  class Coverage
    attr_reader :path

    DEFAULT_PARAMETERS = {
      defaultInterpolationMethod: "nearest neighbor",
      enabled: true,
      interpolationMethods: {
        string: ["nearest neighbor", "bilinear", "bicubic"]
      },
      parameters: {
        entry: [
          { string: ["BackgroundValues", "0"] },
          { string: [ "InputTransparentColor", "nodata" ] },
          { string: [ "OutputTransparentColor", "nodata" ] },
          { string: [ "SUGGESTED_TILE_SIZE", "512,512" ] },
          { string: [ "FootprintBehavior", "Cut" ] },
          { string: [ "USE_MULTITHREADING", true ] },
          { string: [ "USE_JAI_IMAGEREAD", false ] }
        ]
      },
      projectionPolicy: "REPROJECT_TO_DECLARED",
      requestSRS: { string: ["EPSG:4326"] },
      responseSRS: { string: ["EPSG:4326"] },
      supportedFormats: {
        string: [ "ArcGrid", "ERDASImg", "DTED", "RST", "AIG", "GEOTIFF",
          "ENVIHdr", "VRT", "Gtopo30", "EHdr", "RPFTOC", "ImageMosaic", "NITF",
          "GIF", "PNG", "JPEG", "TIFF" ]
      }
    }

    def initialize(server, parent_path, parameters = {})
      @server = server
      @parent_path = parent_path
      @path = nil
      @parameters = DEFAULT_PARAMETERS.merge(parameters)
    end

    def parse(json)
      body = JSON.parse(json, symbolize_names: true)
      @parameters = body[:coverage]
    end

    # Save the Coverage to the server, and store the updated response as
    # the new Coverage parameters.
    def save
      response = @server.post("#{@parent_path}/coverages", JSON.generate({ "coverage" => @parameters }))
      raise ArgumentError, "Error creating coverage.\n #{response}" if response.code != "201"
      @path = response.header["Location"]
      parse(@server.get(@path).body)
      self
    end

    def [](key)
      @parameters[key]
    end
  end
end
