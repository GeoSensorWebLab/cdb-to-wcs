module CDBTool
  class CLI
    attr_accessor :cdb_path, :logfile, :verbose
    attr_reader :parser, :options

    # Class for command line options
    class CLIOptions
      attr_accessor :debug, :verbose

      def initialize
        self.debug = nil
        self.verbose = 0
      end

      def define_options(parser, help_info)
        parser.banner = "Usage: $1 [options]"
        parser.separator help_info
        parser.separator "Common options:"

        parser.on_tail("-d FILE", "--debug=FILE", "Log debug output to FILE") do |file|
          self.debug = file
        end

        parser.on_tail("-v", "--verbose", "Increase stdout verbosity") do |file|
          self.verbose += 1
        end

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
      if @options.debug
        validate_debug!(@options.debug)
        self.logfile = @options.debug
      end

      self.verbose = @options.verbose

      @options
    end

    def log(msg)
      IO.write(self.logfile, "#{Time.now}, #{msg}\n", mode: 'a') if self.logfile
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

    def validate_debug!(file)
      if File.exist?(file) && !File.writable?(file)
        puts "Debug file '#{file}' not writable"
        exit 1
      end
    end
  end
end
