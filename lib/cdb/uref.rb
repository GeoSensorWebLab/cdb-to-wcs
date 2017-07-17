module CDB
  # Class for UREF directories
  class UREF < CDBFile

    # Array of CS1 values found in entries
    def cs1_list
      entries.collect { |entry|
        file = CDBFile.new(entry)
        file.fields.at(2)
      }.uniq
    end

    # Array of CS2 values found in entries
    def cs2_list
      entries.collect { |entry|
        file = CDBFile.new(entry)
        file.fields.at(3)
      }.uniq
    end

    # Return hash of entries in the UREF, grouped by Component Selector 1
    # Keys: CS1
    # Values: Arrays of files
    def files_by_cs1
      entries.group_by do |entry|
        file = CDBFile.new(entry)
        file.fields.at(2)
      end
    end

    # Return hash of entries in the UREF, grouped by Component Selector 2
    # Keys: CS2
    # Values: Arrays of files
    def files_by_cs2
      entries.group_by do |entry|
        file = CDBFile.new(entry)
        file.fields.at(3)
      end
    end

    # Return hash of entries in the UREF, grouped by Component Selector 1 then
    # by Component Selector 2
    # Keys: CS1
    # Values: Hash
    #    Keys: CS2
    #    Values: Files
    def files_by_components
      components = {}
      entries.each do |entry|
        file = CDBFile.new(entry)
        cs1 = file.fields.at(2)
        cs2 = file.fields.at(3)

        components[cs1] ||= {}
        components[cs1][cs2] ||= []
        components[cs1][cs2].push(file)
      end
      components
    end

    private

  end
end
