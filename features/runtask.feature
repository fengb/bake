Feature: running tasks
  In order to run defined tasks
  I want to execute commands

  Scenario: basic execution
    Given the task "Bakefile/task"
     When I execute "bake task"
     Then the task should have executed

  Scenario: execution with arguments
    Given the task "Bakefile/task"
     When I execute "bake task more work?"
     Then the task should have executed with arguments "more work?"

  Scenario: task is nonexistent
     When I execute "bake nonexistent"
     Then I get the error:
          """
          -bake: nonexistent: does not exist
          """

  Scenario: attempted execution of non executable
    Given the file "Bakefile/file"
     When I execute "bake file"
     Then I get the error:
          """
          -bake: file: not executable
          """
