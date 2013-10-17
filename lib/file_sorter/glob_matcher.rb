require_relative 'matcher'

module FileSorter
  class GlobMatcher < Matcher
    def matches?(filename)
      super && File.fnmatch?(pattern, File.basename(filename))
    end
  end
end
