require 'test_helper.rb'

module FileSorter
  class FileSorterTest < ActiveSupport::TestCase
    test 'should use default config file' do
      fs = FileSorter.new
      assert fs.options.include?(:config_file)
    end

    test 'should use given config file' do
      fs = FileSorter.new(config_file: 'foo_bar')
      assert_equal 'foo_bar', fs.options[:config_file]
    end

    test 'should process files from all folders in config' do
      config = stub(folders: %w(foo bar))
      fs = FileSorter.new
      fs.stubs(config: config)
      Dir.expects(:glob).with('foo/*').returns(%w(a b))
      Dir.expects(:glob).with('bar/*').returns(%w(c d))

      assert_equal %w(a b c d), fs.relevant_files
    end

    test 'should not perform actions on dry run' do
      matcher = mock
      matcher.expects(:handle).never
      fs = FileSorter.new(dry_run: true)
      fs.expects(:relevant_files).returns(%w(a))
      fs.expects(:matcher_for).with('a').returns(matcher)
      quietly do
        fs.sort!
      end
    end

    test 'should call matcher handler on match' do
      matcher = mock
      matcher.expects(:handle).with('a')
      fs = FileSorter.new
      fs.expects(:relevant_files).returns(%w(a))
      fs.expects(:matcher_for).with('a').returns(matcher)
      quietly do
        fs.sort!
      end
    end
  end
end
