require 'fileutils'


def file(path, options={})
  contents = options.delete(:contents) || ''
  executable = options.delete(:type) == 'task'

  FileUtils.mkdir_p File.dirname(path)
  File.open(path, 'w') do |file|
    file.write(contents)
  end
  FileUtils.chmod(0700, path) if executable
end


Given 'the directory "$dir"' do |dir|
  FileUtils.mkdir_p(dir)
end

Given /^the (file|task) "([^ ]*)"$/ do |type, path|
  file(path, type: type)
end

Given /^the (file|task) "(.*)" with contents "(.*)"$/ do |type, path, contents|
  file(path, type: type, contents: contents)
end

Given /^the (file|task) "(.*)" with contents:$/ do |type, task, contents|
  file(task, type: type, contents: contents)
end

Given /^the following (file|task)s:$/ do |type, table|
  table.rows.each do |(file, contents)|
    file(file, type: type, contents: contents)
  end
end

Given 'the capture task "$task"' do |task|
  file(task, type: 'task', contents: "#!/bin/bash
                                      echo 'Work completed!' $@")
end

When 'I am in the "$dir" directory' do |dir|
  FileUtils.cd File.join(WORK_DIR, dir)
end

When 'I execute "bake$args"' do |args|
  cmd "#{PROJ_DIR}/#{BAKE_EXEC} #{args}"
end

def expect_output(string)
  expect(last_cmd.stderr.chomp) == ''
  stdout = last_cmd.stdout.chomp.gsub(/ *$/, '')
  expect(stdout) == string
  expect(last_cmd.exitstatus) == 0
end

Then 'I see on the output "$output"' do |output|
  expect_output(output)
end

Then 'I see on the output:' do |output|
  expect_output(output)
end

Then 'I get the error "$error"' do |error|
  expect(last_cmd.stderr.chomp) == error
  expect(last_cmd.exitstatus) != 0
end

def expect_capture(capture)
  expect(last_cmd.stderr.chomp) == ''
  expect(last_cmd.stdout.lines.to_a.last.chomp) == capture
  expect(last_cmd.exitstatus) == 0
end

Then 'the capture task should have executed' do
  expect_capture('Work completed!')
end

Then 'the capture task should have executed with arguments "$args"' do |args|
  expect_capture("Work completed! #{args}")
end
