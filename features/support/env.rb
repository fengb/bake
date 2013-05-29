require 'fileutils'
require 'tmpdir'


PROJ_DIR = Dir.pwd
BAKE_EXEC = ENV['BAKE_EXEC'] || 'bin/bake'

Before do
  @work_dir = Dir.mktmpdir
  FileUtils.cd @work_dir
end

After do
  FileUtils.cd PROJ_DIR
  FileUtils.rm_rf @work_dir
end
