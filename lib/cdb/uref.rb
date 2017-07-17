module CDB
  # Class for UREF directories
  class UREF < CDBFile

    # Return entries in the UREF, grouped by Component Selector 1
    def files_by_cs1
      entries.group_by do |entry|
        file = CDBFile.new(entry)
        file.fields.at(2)
      end
    end

    # Return entries in the UREF, grouped by Component Selector 2
    def files_by_cs2
      entries.group_by do |entry|
        file = CDBFile.new(entry)
        file.fields.at(3)
      end
    end

    private

  end
end
