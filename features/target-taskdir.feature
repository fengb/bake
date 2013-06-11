Feature: target taskdir
  In order to execute bake from shell scripts
  I want to use an absolute path for holding files

  Scenario: executing task within target taskdir
      Given the capture task "path/to/tasks/task"
       When I execute "bake -b path/to/tasks task"
       Then the capture task should have executed

  Scenario: target taskdir does not exist
       When I execute "bake -b path/to/tasks task"
       Then I get the error "-bake: path/to/tasks: taskdir not found"
