require 'fileutils'


def bakefile(path, contents)
  FileUtils.mkdir_p File.dirname(path)
  File.open(path, 'w') do |file|
    file.write(contents)
  end
end


Given 'the file "$path" with contents "$contents"' do |path, contents|
  bakefile(path, contents)
end

Given 'the file "$path" with contents:' do |path, contents|
  bakefile(path, contents)
end

Given 'the following files:' do |table|
  table.rows.each do |(path, contents)|
    bakefile(path, contents)
  end
end

When 'I execute "bake$args"' do |args|
  cmdline "#{PROJ_DIR}/src/bake.sh #{args}"
end

Then 'I see on stdout:' do |string|
  assert_equal '', last_cmdline.stderr.chomp
  assert_equal string, last_cmdline.stdout.chomp
end
