Feature: command-line help
  In order to glean information of tasks
  I want to obtain simple descriptions

  Scenario: simple file
    Given the Bakefile "task" with contents "### Something"
     When I execute "bake"
     Then I see on stdout:
          """
          task # Something
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
          | task  | ### First  |
          | task2 | ### Second |
     When I execute "bake"
     Then I see on stdout:
          """
          task # First
          task2 # Second
          """
