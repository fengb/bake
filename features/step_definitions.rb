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

Given /^the task "([^ ]*)"$/ do |task|
  file(task, executable: true)
end

Given 'the capture task "$task"' do |task|
  file(task, executable: true, contents: "#!/bin/bash
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

def expect_output(string)
  expect(last_cmd.stderr.chomp) == ''
  expect(last_cmd.stdout.chomp) == string
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

Then 'the capture task should have executed' do
  expect_output('Work completed!')
end

Then 'the capture task should have executed with arguments "$args"' do |args|
  expect_output("Work completed! #{args}")
end
