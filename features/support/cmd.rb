require 'open3'


class Cmd
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

  module Helper
    def cmd(command, options={})
      @cmd = Cmd.new(command, options)
      @cmd.execute
      @cmd
    end

    def last_cmd
      @cmd
    end
  end
end
World(Cmd::Helper)
