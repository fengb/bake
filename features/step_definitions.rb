require 'fileutils'


def bakefile(path, contents)
  path = File.join("Bakefile", path)
  FileUtils.mkdir_p File.dirname(path)
  File.open(path, 'w') do |file|
    file.write(contents)
  end
end


Given 'the Bakefile "$path" with contents "$contents"' do |path, contents|
  bakefile(path, contents)
end

Given 'the Bakefile "$path" with contents:' do |path, contents|
  bakefile(path, contents)
end

Given 'the following Bakefiles:' do |table|
  table.rows.each do |(path, contents)|
    bakefile(path, contents)
  end
end

When 'I execute "bake$args"' do |args|
  cmdline "#{PROJ_DIR}/src/bake.sh #{args}"
end

Then 'I see on stdout:' do |string|
  last_cmdline.stderr.chomp.should == ''
  last_cmdline.stdout.chomp.should == string
end
