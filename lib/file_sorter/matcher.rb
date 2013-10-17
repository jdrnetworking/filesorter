require 'active_support/core_ext/string/inflections'

module FileSorter
  class Matcher
    attr_reader :options, :pattern

    def initialize(pattern, options = {})
      @pattern = pattern
      @options = options
    end

    def matches?(filename)
      return File.expand_path(filename).start_with?(options[:folder]) if options[:folder]
      true
    end

    def handle(filename)
      options[:handler].call(filename) if options.key?(:handler)
    end

    def to_s
      "<#{self.class.name.demodulize} pattern=\"#{pattern}\"#{" (#{options[:description]})" if options.key?(:description)}>"
    end
  end
end
