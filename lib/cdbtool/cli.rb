module CDBTool
  class CLI
    attr_reader :parser, :options

    # Class for command line options
    class CLIOptions
      attr_accessor :cdb_path

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

        parser.on_tail("--version", "Show version") do
          puts Version
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
      @options
    end
  end
end
