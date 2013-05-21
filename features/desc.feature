Feature: command-line help
  In order to glean information of tasks
  I want to obtain simple descriptions

  Scenario: simple task
    Given the task "Bakefile/task" with contents "### Some feature"
     When I execute "bake"
     Then I see on stdout:
          """
          task # Some feature
          """

  Scenario: task with no description
    Given the task "Bakefile/task"
     When I execute "bake"
     Then I see on stdout:
          """
          task
          """

  Scenario: task with no description
    Given the file "Bakefile/file"
     When I execute "bake"
     Then I see on stdout:
          """
          file !! not executable
          """

  Scenario: multi-line task
    Given the task "Bakefile/task" with contents:
          """
          #!/bin/bash

          ### Cleans stuff

          rm -rf /
          """
     When I execute "bake"
     Then I see on stdout:
          """
          task # Cleans stuff
          """

  Scenario: multiple tasks
    Given the following tasks:
          | path           | contents   |
          | Bakefile/task  | No comment |
          | Bakefile/task2 | ### Second |
     When I execute "bake"
     Then I see on stdout:
          """
          task
          task2 # Second
          """

  Scenario: tasks located above the current directory
    Given the task "Bakefile/task"
      And the directory "lib"
     When I am in the "lib" directory
      And I execute "bake"
     Then I see on stdout:
          """
          task
          """
