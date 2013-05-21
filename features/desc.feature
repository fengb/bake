Feature: command-line help
  In order to glean information of tasks
  I want to obtain simple descriptions

  Scenario: simple file
    Given the Bakefile "task" with contents "### Some feature"
     When I execute "bake"
     Then I see on stdout:
          """
          task # Some feature
          """

  Scenario: file with no description
    Given the Bakefile "task" with contents "tough noodles"
     When I execute "bake"
     Then I see on stdout:
          """
          task
          """

  Scenario: multi-line file
    Given the Bakefile "task" with contents:
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

  Scenario: multiple files
    Given the following Bakefiles:
          | path  | contents   |
          | task  | No comment |
          | task2 | ### Second |
     When I execute "bake"
     Then I see on stdout:
          """
          task
          task2 # Second
          """
