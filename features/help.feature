Feature: command-line help
  In order to glean information of tasks
  I want to obtain simple descriptions

  Scenario: simple task
      Given the task "Bakefile/task"
       When I execute "bake -h"
       Then I see on stdout "task"

  Scenario: task with description
      Given the task "Bakefile/task" with contents "### Some feature"
       When I execute "bake -h"
       Then I see on stdout "task  ##  Some feature"

  Scenario: non-executable file
      Given the file "Bakefile/file"
       When I execute "bake -h"
       Then I see on stdout "file  !!  not executable"

  Scenario: non-executable file explicitly marked as not bake
      Given the file "Bakefile/file" with contents "==-==-=="
       When I execute "bake -h"
       Then I see on stdout ""

  Scenario: directory default task
      Given the task "Bakefile/dir/{default}"
       When I execute "bake -h"
       Then I see on stdout "dir"

  Scenario: task with an extension
      Given the task "Bakefile/task.ext"
       When I execute "bake -h"
       Then I see on stdout "task"

  Scenario: multi-line task
      Given the task "Bakefile/task" with contents:
            """
            ### Cleans stuff

            rm -rf /
            """
       When I execute "bake -h"
       Then I see on stdout "task  ##  Cleans stuff"

  Scenario: super task
      Given the task "Bakefile/task" with contents:
            """
                $BAKE pie 1
                $BAKE cake 2
            """
       When I execute "bake -h"
       Then I see on stdout "task  ->  pie cake"

  Scenario: multiple tasks
      Given the tasks:
            | Bakefile/task  | No comment |
            | Bakefile/task2 | ### Second |
       When I execute "bake -h"
       Then I see on stdout:
            """
            task
            task2  ##  Second
            """

  Scenario: tasks located above the current directory
      Given the task "Bakefile/task"
        And the directory "lib"
       When I am in the "lib" directory
        And I execute "bake -h"
       Then I see on stdout "task"
