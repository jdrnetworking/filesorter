require 'minitest_helper.rb'

module FileSorter
  class GlobMatcherTest < ActiveSupport::TestCase
    test 'should match with glob syntax' do
      matcher = GlobMatcher.new('a?b')
      assert matcher.matches?('a_b')
      assert matcher.matches?('acb')
      refute matcher.matches?('ab')
    end

    test 'should match filename with folder if specified' do
      matcher = GlobMatcher.new('b?r', folder: '/foo_folder')
      assert matcher.matches?('/foo_folder/bar')
      refute matcher.matches?('/bar_folder/bar')
      refute matcher.matches?('/foo_folder/baz')
    end
  end
end
