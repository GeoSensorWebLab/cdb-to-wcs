module CDB
  # Class to provide quick methods to get CDB contents
  class CDB
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def latcells
      @latcells ||= scan_latcells
    end

    def loncells
      @loncells ||= scan_loncells
    end

    def datasets
      @datasets ||= scan_datasets
    end

    private

    def scan_latcells
      Dir.glob(@path + "/Tiles/*").collect do |entry|
        CDBFile.new(entry)
      end
    end

    def scan_loncells
      latcells.collect do |latcell|
        Dir.glob(latcell.path + "/*").collect do |entry|
          CDBFile.new(entry)
        end
      end.flatten
    end

    def scan_datasets
      loncells.collect do |loncell|
        Dir.glob(loncell.path + "/*").collect do |entry|
          Dataset.new(entry)
        end
      end.flatten
    end

  end
end
