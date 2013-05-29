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

When 'I am in the "$dir" directory' do |dir|
  FileUtils.cd File.join(@work_dir, dir)
end

When 'I execute "bake$args"' do |args|
  cmd "#{PROJ_DIR}/#{BAKE_EXEC} #{args}"
end

def expect_output(stream, string)
  case stream
    when 'stderr'
      @expected_stderr = last_cmd.stderr.chomp.gsub(/ *$/, '')
      expect(@expected_stderr) == string
    when 'stdout'
      expect(last_cmd.stderr.strip) == '' unless @expected_stderr
      stdout = last_cmd.stdout.chomp.gsub(/ *$/, '')
      expect(stdout) == string
    else
      raise 'wtf stream?'
  end
end

Then /^I see on (stderr|stdout) "(.*)"$/ do |stream, output|
  expect_output(stream, output)
end

Then /^I see on (stderr|stdout):$/ do |stream, output|
  expect_output(stream, output)
end

Then 'I get the error "$error"' do |error|
  expect(last_cmd.stderr.chomp) == error
  expect(last_cmd.exitstatus) != 0
end

def expect_capture(args='')
  expect(last_cmd.stderr.chomp) == args
  expect(last_cmd.exitstatus) == 42
end

Given 'the capture task "$task"' do |task|
  file(task, type: 'task', contents: %Q{#!/bin/bash
                                        [ "$#" -ne 0 ] && echo "$@" >&2
                                        exit 42})
end

Then 'the capture task should have executed' do
  expect_capture
end

Then 'the capture task should have executed with arguments "$args"' do |args|
  expect_capture(args)
end
