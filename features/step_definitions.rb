require 'fileutils'


def file(path, contents='')
  FileUtils.mkdir_p File.dirname(path)
  File.open(path, 'w') do |file|
    file.write(contents)
  end
end


Given 'the directory "$dir"' do |dir|
  FileUtils.mkdir_p(dir)
end

Given /^the file "([^ ]*)"$/ do |file|
  file(file)
end

Given 'the file "$file" with contents "$contents"' do |file, contents|
  file(file, contents)
end

Given 'the file "$file" with contents:' do |file, contents|
  file(file, contents)
end

Given 'the following files:' do |table|
  table.rows.each do |(file, contents)|
    file(file, contents)
  end
end

When 'I am in the "$dir" directory' do |dir|
  FileUtils.cd File.join(WORK_DIR, dir)
end

When 'I execute "bake$args"' do |args|
  cmdline "#{PROJ_DIR}/src/bake.sh #{args}"
end

Then 'I see on stdout:' do |string|
  expect(last_cmdline.stderr.chomp) == ''
  expect(last_cmdline.stdout.chomp) == string
end
