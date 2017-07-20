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
      Net::HTTP.start(@uri.host, @uri.port, @http_options) do |http|
        request = Net::HTTP::Get.new(path)
        request.basic_auth @uri.user, @uri.password
        request['Accept'] = 'application/json'

        http.request(request)
      end
    end

    def post(path, data)
      Net::HTTP.start(@uri.host, @uri.port, @http_options) do |http|
        request = Net::HTTP::Post.new(path)
        request.basic_auth @uri.user, @uri.password
        request['Accept'] = 'application/json'
        request.content_type = 'application/json'
        request.body = data

        http.request(request)
      end
    end

    def delete(path)
      Net::HTTP.start(@uri.host, @uri.port, @http_options) do |http|
        request = Net::HTTP::Delete.new(path)
        request.basic_auth @uri.user, @uri.password
        request['Accept'] = 'application/json'

        http.request(request)
      end
    end

  end
end
