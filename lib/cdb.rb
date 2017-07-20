require "cdb/cdb"
require "cdb/cdb_file"
require "cdb/dataset"
require "cdb/lod"
require "cdb/uref"
require "cdb/version"

module CDB
  # Returns the filetype expected for a dataset ID.
  # Basically Imagery is JPEG2000 and everything else is GeoTIFF.
  def self.filetype_for_dataset_id(dataset_id)
    dataset_id.include?("004_Imagery") ? "jp2" : "tif"
  end
end
