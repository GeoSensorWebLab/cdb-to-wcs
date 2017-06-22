module CDB
  # Class for LOD directories
  class LOD < CDBFile
    def urefs
      @urefs ||= scan_urefs
    end

    private

    def scan_urefs
      Dir.glob(@path + "/U*").collect do |entry|
        CDBFile.new(entry)
      end
    end
  end
end
