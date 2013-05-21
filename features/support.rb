require 'fileutils'
require 'open3'
require 'test/unit/assertions'


class CommandLine
  module CukeHelpers
    def cmdline(command, options={})
      @last_cmdline = CommandLine.new(command, options)
      @last_cmdline.execute
      @last_cmdline
    end

    def last_cmdline
      @last_cmdline
    end
  end

  attr_reader :command, :options, :stderr, :stdout

  def initialize(command, options={})
    @command, @options = command, options
  end

  def execute
    @stdout, @stderr, @status = Open3.capture3(command, @options)
  end

  def exitstatus
    @status.exitstatus
  end
end

World(CommandLine::CukeHelpers)
World(Test::Unit::Assertions)


PROJ_DIR = Dir.pwd
WORK_DIR = File.join(PROJ_DIR, 'work')

Before do
  FileUtils.mkdir_p WORK_DIR
  FileUtils.cd WORK_DIR
end

After do
  FileUtils.cd PROJ_DIR
  FileUtils.rm_rf WORK_DIR
end
