require 'minitest_helper.rb'

module FileSorter
  class ConfigTest < ActiveSupport::TestCase
    test 'should create glob matcher with default behavior' do
      input = "glob 'a?b', '/foo_folder'"
      config = Config.load_string(input)
      assert_equal 1, config.matchers.size
      matcher = config.matchers.first
      assert_equal 'a?b', matcher.pattern
      assert_equal 'move to /foo_folder', matcher.options[:description]
      assert matcher.matches?('a_b')
    end

    test 'should create regex matcher with default behavior' do
      input = "regex 'a?b$', '/foo_folder'"
      config = Config.load_string(input)
      assert_equal 1, config.matchers.size
      matcher = config.matchers.first
      assert_equal 'a?b$', matcher.pattern
      assert_equal 'move to /foo_folder', matcher.options[:description]
      assert matcher.matches?('ab')
      assert matcher.matches?('b')
      refute matcher.matches?('ab ')
    end

    test 'should use given behavior' do
      input = <<-EOI
        glob '*', 'upcase' do |filename|
          filename.upcase
        end
      EOI
      config = Config.load_string(input)
      matcher = config.matchers.first
      assert_equal 'upcase', matcher.options[:description]
      assert_equal 'FOO', matcher.handle('foo')
    end

    test 'should add folder to folder list' do
      input = "folder '/foo_folder'"
      config = Config.load_string(input)
      assert_equal 1, config.folders.size
      assert_equal "/foo_folder", config.folders.first
    end

    test 'should add folder context on matchers in folder block' do
      input = <<-EOI
        folder '/bar_folder' do
          glob 'b?r', '/foo_folder'
        end
      EOI
      config = Config.load_string(input)
      assert_equal 1, config.folders.size
      assert_equal "/bar_folder", config.folders.first
      assert_equal 1, config.matchers.size
      matcher = config.matchers.first
      assert_equal 'b?r', matcher.pattern
      assert_equal 'move to /foo_folder', matcher.options[:description]
      assert matcher.matches?('/bar_folder/bar')
      refute matcher.matches?('bar')
    end

    test 'should clear folder context after folder block' do
      input = <<-EOI
        folder '/bar_folder' do
          glob 'b?r', '/foo_folder'
        end
        glob 'b?z', '/baz_folder'
      EOI
      config = Config.load_string(input)
      assert_equal 1, config.folders.size
      assert_equal "/bar_folder", config.folders.first
      assert_equal 2, config.matchers.size
      matcher = config.matchers.last
      assert_equal 'b?z', matcher.pattern
      assert matcher.matches?('/bar_folder/baz')
      assert matcher.matches?('/qux_folder/baz')
    end
  end
end
