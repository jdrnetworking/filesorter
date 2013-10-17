require_relative 'glob_matcher'
require_relative 'regex_matcher'

module FileSorter
  class Config
    attr_reader :context_options, :folders, :matchers

    def initialize
      @folders = []
      @matchers = []
      @context_options = {}
    end

    def folder(path)
      expanded_path = File.expand_path(path)
      folders << expanded_path unless folders.include?(expanded_path)
      if block_given?
        @context_options[:folder] = expanded_path
        yield
        @context_options.delete(:folder)
      end
    end

    def glob(pattern, move_to_or_description, &block)
      options = context_options.merge(default_handler(move_to_or_description, &block))
      @matchers << GlobMatcher.new(pattern, options)
    end

    def regex(pattern, move_to_or_description, &block)
      options = context_options.merge(default_handler(move_to_or_description, &block))
      @matchers << RegexMatcher.new(pattern, options)
    end

    def self.load_file(filename)
      load_string File.read(filename)
    end

    def self.load_string(input)
      new.tap do |config|
        config.instance_eval input
      end
    end

    private

    def default_handler(move_to_or_description, &block)
      raise ArgumentError, "Provide one of: move_to or block" unless move_to_or_description || block_given?
      if block_given?
        {
          handler: block,
          description: move_to_or_description
        }
      else
        move_to = File.expand_path(move_to_or_description)
        {
          handler: ->(filename) {
            FileUtils.mv File.expand_path(filename), move_to
          },
          description: "move to #{move_to}"
        }
      end
    end
  end
end
