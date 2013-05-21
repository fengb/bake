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
