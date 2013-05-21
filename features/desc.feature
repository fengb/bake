Feature: command-line help
  In order to glean information of tasks
  I want to obtain simple descriptions

  Scenario: simple file
    Given the Bakefile "tasks/task" with contents "### Something"
     When I execute "bake"
     Then I see on stdout
     """
     task # Something
     """

  Scenario: multiple files
    Given the following Bakefiles:
          | path        | contents   |
          | tasks/task  | ### First  |
          | tasks/task2 | ### Second |
     When I execute "bake"
     Then I see on stdout
     """
     task # First
     task2 # Second
     """
