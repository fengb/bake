require 'fileutils'


Given 'the Bakefile "$path" with contents "$contents"' do |path, contents|
  FileUtils.mkdir_p File.dirname(path)
  File.open(path, 'w') do |file|
    file.write(contents)
  end
end

When 'I execute "bake$args"' do |args|
  cmdline "#{PROJ_DIR}/src/bake.sh #{args}"
end

Then 'I see on stdout' do |string|
  last_cmdline.stderr.strip.should == ''
  last_cmdline.stdout.strip.should == string
end
