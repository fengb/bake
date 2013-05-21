require 'fileutils'


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