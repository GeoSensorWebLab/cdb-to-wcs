module CDB
  # Class for Datasets
  # Use for quick access to all coverages under the dataset
  class Dataset < CDBFile
    def all_files
      @all_files ||= urefs.collect { |uref| uref.entries }.flatten
    end

    def components
      @components ||= scan_components
    end

    def cs1_list
      @cs1 ||= urefs.collect { |uref| uref.cs1_list }.flatten.uniq
    end

    def cs2_list
      @cs2 ||= urefs.collect { |uref| uref.cs2_list }.flatten.uniq
    end

    def geocell
      lon = File.basename(File.dirname(@path))
      lat = File.basename(File.dirname(File.dirname(@path)))
      "#{lat}-#{lon}"
    end

    def lods
      @lods ||= scan_lods
    end

    def sorted_lods
      @sorted_lods ||= lods.sort { |a,b| a.id <=> b.id }
    end

    def lowest_lod
      if lods.include?("LC")
        "LC"
      else
        sorted_lods.pop
      end
    end

    # Return highest LOD.
    # Sorting will go from L00 to L20, with LC last. That leaves the highest
    # LOD as second last unless there is only one LOD then -2 will return nil.
    # In that case, return the last LOD.
    def highest_lod
      sorted_lods[-2] || sorted_lods[-1]
    end

    def urefs
      @urefs ||= lods.collect { |lod| lod.urefs }.flatten
    end

    private

    # Collect all the files in the dataset under ALL UREFs and group by CS1
    # then group by CS2.
    def scan_components
      components = {}
      urefs.each do |uref|
        uref.files_by_components.each do |cs1, cs2s|
          components[cs1] ||= {}

          cs2s.each do |cs2, files|
            components[cs1][cs2] ||= []
            components[cs1][cs2].concat(files)
          end
        end
      end
      components
    end

    def scan_lods
      Dir.glob(@path + "/L*").collect do |entry|
        LOD.new(entry)
      end
    end
  end
end
