Feature: command-line help
  In order to glean information of tasks
  I want to obtain simple descriptions

  Scenario: simple task
    Given the task "Bakefile/task"
     When I execute "bake"
     Then I see on the output "task"

  Scenario: task with description
    Given the task "Bakefile/task" with contents "### Some feature"
     When I execute "bake"
     Then I see on the output "task  ##  Some feature"

  Scenario: task with no description
    Given the file "Bakefile/file"
     When I execute "bake"
     Then I see on the output "file  !!  not executable"

  Scenario: task with an extension
    Given the task "Bakefile/task.ext"
     When I execute "bake"
     Then I see on the output "task"

  Scenario: multi-line task
    Given the task "Bakefile/task" with contents:
          """
          #!/bin/bash

          ### Cleans stuff

          rm -rf /
          """
     When I execute "bake"
     Then I see on the output "task  ##  Cleans stuff"

  Scenario: super task
    Given the task "Bakefile/task" with contents:
          """
          #!/bin/bash

          $BAKE pie 1
          $BAKE cake 2
          """
     When I execute "bake"
     Then I see on the output "task  ->  pie cake"

  Scenario: multiple tasks
    Given the following tasks:
          | path           | contents   |
          | Bakefile/task  | No comment |
          | Bakefile/task2 | ### Second |
     When I execute "bake"
     Then I see on the output:
          """
          task
          task2  ##  Second
          """

  Scenario: tasks located above the current directory
    Given the task "Bakefile/task"
      And the directory "lib"
     When I am in the "lib" directory
      And I execute "bake"
     Then I see on the output "task"
