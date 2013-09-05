require 'test_helper.rb'

module FileSorter
  class RegexMatcherTest < ActiveSupport::TestCase
    test 'should match with regex syntax' do
      matcher = RegexMatcher.new('\d+$')
      assert matcher.matches?('1234')
      refute matcher.matches?('1234 ')
      refute matcher.matches?('abcd')
    end

    test 'should match filename with folder if specified' do
      matcher = RegexMatcher.new('\d+$', folder: '/foo_folder')
      assert matcher.matches?('/foo_folder/bar_1234')
      refute matcher.matches?('/bar_folder/bar_1234')
      refute matcher.matches?('/foo_folder/bar')
    end
  end
end
