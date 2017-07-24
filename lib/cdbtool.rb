require "cdbtool/cli"

require "fileutils"
require "logging"
require "optparse"

module CDBTool
  # Create a linked file to save space when only a single file is mosaiced
  def self.link_output(input_file, output_file)
    if File.exists?(input_file) && !File.exists?(output_file)
      puts "Linking source #{input_file} to #{output_file}"
      FileUtils.ln_s(input_file, output_file)
    end
  end

  # Create a directory, but do nothing if it already exists
  def self.mkdirp(dir)
    if !Dir.exists?(dir)
      Dir.mkdir(dir)
    end
  end
end
