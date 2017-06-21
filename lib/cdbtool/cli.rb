module CDBTool
  class CLI
    attr_accessor :cdb_path
    attr_reader :parser, :options

    # Class for command line options
    class CLIOptions
      def initialize
      end

      def define_options(parser, help_info)
        parser.banner = "Usage: $1 [options]"
        parser.separator help_info
        parser.separator "Common options:"

        parser.on_tail("-h", "--help", "Show this message") do
          puts parser
          exit
        end
      end
    end

    # Subclasses should override this
    def help_info
      ""
    end

    #
    # Return a structure describing the options.
    #
    def parse(args)
      # The options specified on the command line will be collected in
      # *options*.

      @options = CLIOptions.new
      @args = OptionParser.new do |parser|
        @options.define_options(parser, help_info)
        parser.parse!(args)
      end

      @cdb_path = args.shift

      @options
    end

    def validate_cdb!
      if !Dir.exists?(@cdb_path)
        puts "CDB directory does not exist!"
        exit 1
      end

      if !Dir.exists?(@cdb_path + "/Tiles")
        puts "CDB Tiles directory does not exist!"
        exit 1
      end
    end
  end
end
