# FileSorter

FileSorter does things to files.  Whatever you want.  Run with `-h` for help, `-v` to print matched files as they're processed, and `-n` for a dry run.

## Config Examples
A bare `folder` statement will process all files in that folder:

	folder '~/Downloads'

By default, matchers move matched files to a location of your choosing.

	glob '*.pdf', '~/Documents'

Regexes are also supported:

	regex 'CIMG\d+.JPG', '~/Pictures'

You can also pass a block to the matcher and it will run arbitrary code.  In this form, the second argument is a description of the matcher.

	glob '*.JPG', 'uppercase extensions are YUCK' do |filename|
	  expanded_filename = File.expand_path(filename)
	  new_filename = expanded_filename.gsub(/\.[A-Z]+$/) { |match| match.downcase }
	  FileUtils.mv expanded_filename, new_filename
	end

Matchers defined in a folder block will only match files in that folder:

	folder '~/Downloads' do
	  glob '*.pdf', '~/Documents'  # will only match PDFs in ~/Downloads
	end

	folder '~/Desktop'
	glob '*.pdf', '~/Pictures' # will move PDfs in ~/Desktop to ~/Pictures
	
When multiple matchers match a filename, the first matcher defined wins.