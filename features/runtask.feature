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
