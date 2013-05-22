require 'fileutils'


def file(path, options={})
  contents = options.delete(:contents) || ''
  executable = options.delete(:executable) || false

  FileUtils.mkdir_p File.dirname(path)
  File.open(path, 'w') do |file|
    file.write(contents)
  end
  FileUtils.chmod(0700, path) if executable
end


Given 'the directory "$dir"' do |dir|
  FileUtils.mkdir_p(dir)
end

Given /^the file "([^ ]*)"$/ do |file|
  file(file)
end

Given /^the task "([^ ]*)"$/ do |file|
  file(file, executable: true, contents: "#!/bin/bash
                                          echo 'Work completed!' $@")
end

Given 'the task "$task" with contents "$contents"' do |task, contents|
  file(task, executable: true, contents: contents)
end

Given 'the task "$task" with contents:' do |task, contents|
  file(task, executable: true, contents: contents)
end

Given 'the following tasks:' do |table|
  table.rows.each do |(file, contents)|
    file(file, executable: true, contents: contents)
  end
end

When 'I am in the "$dir" directory' do |dir|
  FileUtils.cd File.join(WORK_DIR, dir)
end

When 'I execute "bake$args"' do |args|
  cmd "#{PROJ_DIR}/bin/bake #{args}"
end

def expect_stdout(string)
  expect(last_cmd.exitstatus) == 0
  expect(last_cmd.stderr.chomp) == ''
  expect(last_cmd.stdout.chomp) == string
end

Then 'I see on stdout:' do |string|
  expect_stdout(string)
end

Then 'I get the error:' do |string|
  expect(last_cmd.exitstatus) != 0
  expect(last_cmd.stderr.chomp) == string
end

Then 'the task should have executed' do
  expect_stdout('Work completed!')
end

Then 'the task should have executed with arguments "$args"' do |args|
  expect_stdout("Work completed! #{args}")
end
