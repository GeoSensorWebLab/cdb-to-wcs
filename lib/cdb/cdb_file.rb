module CDB
  # Class for Files/Directories inside CDB
  class CDBFile
    attr_reader :id, :path

    def initialize(path)
      @id = File.basename(path)
      @path = path
    end

    def entries(filter = "/*")
      Dir.glob(@path + filter)
    end
  end
end
