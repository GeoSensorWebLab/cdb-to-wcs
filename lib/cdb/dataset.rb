module CDB
  # Class for Datasets
  # Use for quick access to all coverages under the dataset
  class Dataset < CDBFile
    def all_files
      @all_files ||= urefs.collect { |uref| uref.entries }.flatten
    end

    def geocell
      lon = File.basename(File.dirname(@path))
      lat = File.basename(File.dirname(File.dirname(@path)))
      "#{lat}-#{lon}"
    end

    def lods
      @lods ||= scan_lods
    end

    def urefs
      @urefs ||= lods.collect { |lod| lod.urefs }.flatten
    end

    private

    def scan_lods
      Dir.glob(@path + "/L*").collect do |entry|
        LOD.new(entry)
      end
    end
  end
end
