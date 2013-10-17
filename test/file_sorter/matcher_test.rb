require 'minitest_helper.rb'

module FileSorter
  class MatcherTest < ActiveSupport::TestCase
    test 'should match anything with default options' do
      matcher = Matcher.new('')
      assert matcher.matches?('')
    end

    test 'should match filename with folder if specified' do
      matcher = Matcher.new('', folder: '/foo_folder')
      assert matcher.matches?('/foo_folder/bar')
      refute matcher.matches?('foo_folder/bar')
    end

    test 'should use specified handler' do
      handler = ->(filename) { filename.upcase }
      matcher = Matcher.new('', handler: handler)
      assert_equal 'FOO', matcher.handle('foo')
    end

    test 'should have default description' do
      matcher = Matcher.new('abc')
      assert_equal '<Matcher pattern="abc">', matcher.to_s
    end

    test 'should use given description' do
      matcher = Matcher.new('abc', description: 'move to /foo')
      assert_equal '<Matcher pattern="abc" (move to /foo)>', matcher.to_s
    end
  end
end
