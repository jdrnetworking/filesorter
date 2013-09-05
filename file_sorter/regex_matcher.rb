require_relative 'matcher.rb'

module FileSorter
  class RegexMatcher < Matcher
    def matches?(filename)
      super && Regexp.new(pattern) === filename
    end
  end
end
