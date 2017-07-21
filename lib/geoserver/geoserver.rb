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

    def create_coverage(parent_path, coverage)
      new_coverage = Coverage.new(self, parent_path, coverage)
      new_coverage.save
    end

    def create_coveragestore(parent_path, coveragestore)
      new_cs = CoverageStore.new(self, parent_path, coveragestore)
      new_cs.save
    end

    def create_layer_group(parent_path, layer_group)
      new_layer_group = LayerGroup.new(self, parent_path, layer_group)
      new_layer_group.save
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
