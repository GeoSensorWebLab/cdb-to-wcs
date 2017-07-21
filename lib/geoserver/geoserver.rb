module GeoServer
  class GeoServer
    def initialize(address)
      @uri = URI(address)

      @http_options = {
        use_ssl: @uri.scheme == "https",
        verify_mode: OpenSSL::SSL::VERIFY_NONE,
        read_timeout: @read_timeout
      }
    end

    def base_url
      sprintf("%s://%s:%s", *@uri.select(:scheme, :host, :port))
    end

    def get(path)
      http_request do
        Net::HTTP::Get.new(path)
      end
    end

    def post(path, data)
      http_request do
        request = Net::HTTP::Post.new(path)
        request.content_type = 'application/json'
        request.body = data

        request
      end
    end

    def delete(path)
      http_request do
        Net::HTTP::Delete.new(path)
      end
    end

    def create_coverage(coverage, path)
      response = post("#{path}/coverages", JSON.generate({
        "coverage": coverage
      }))
      raise ArgumentError, "Error creating coverage.\n #{response}" if response.code != "201"
    end

    # path - String
    # coveragestore - Hash
    def create_coveragestore(path, coveragestore)
      new_cs = CoverageStore.new(self, path, coveragestore)
      new_cs.save
    end

    # workspace – Hash
    def create_workspace(workspace)
      new_ws = Workspace.new(self, workspace)
      new_ws.save
    end

    private

    # Wrap out common URI/http settings
    def http_request(&block)
      Net::HTTP.start(@uri.host, @uri.port, @http_options) do |http|
        request = block.call
        request.basic_auth @uri.user, @uri.password
        request['Accept'] = 'application/json'
        http.request(request)
      end
    end

  end
end
