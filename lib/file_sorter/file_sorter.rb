require_relative 'config'

module FileSorter
  class FileSorter
    attr_reader :options

    def initialize(options = {})
      @options = default_options.merge(options)
    end

    def config
      @config ||= Config.load_file(options[:config_file]) if File.exists?(options[:config_file])
    end

    def sort!
      relevant_files.each do |filename|
        matcher = matcher_for(filename)
        next unless matcher
        puts "Handling #{filename} with #{matcher}" if verbose?
        matcher.handle(filename) unless options[:dry_run]
      end
    end

    def relevant_files
      config.folders.map do |folder|
        Dir.glob("#{folder}/*")
      end.inject(&:+)
    end

    private

    def matcher_for(filename)
      config.matchers.detect { |matcher| matcher.matches?(filename) }
    end

    def default_options
      {
        config_file: File.expand_path('~/.filesorter')
      }
    end

    def verbose?
      options[:verbose]
    end
  end
end
