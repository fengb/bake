Feature: running tasks
  In order to run defined tasks
  I want to execute commands

  Scenario: basic execution
    Given the task "Bakefile/task"
     When I execute "bake task"
     Then I see on the output "Baking 'Bakefile/task'"

  Scenario: captured execution
    Given the capture task "Bakefile/task"
     When I execute "bake task"
     Then the capture task should have executed

  Scenario: execution with arguments
    Given the capture task "Bakefile/task"
     When I execute "bake task more work?"
     Then the capture task should have executed with arguments "more work?"

  Scenario: execution without extension
    Given the capture task "Bakefile/task.bash"
     When I execute "bake task"
     Then the capture task should have executed

  Scenario: task is nonexistent
     When I execute "bake nonexistent"
     Then I get the error "-bake: nonexistent: does not exist"

  Scenario: attempted execution of non executable
    Given the file "Bakefile/file"
     When I execute "bake file"
     Then I get the error "-bake: file: not executable"

  Scenario: bakeception
    Given the capture task "Bakefile/captor"
      And the task "Bakefile/initiator" with contents:
          """
          #!/bin/bash
          bake captor
          """
     When I execute "bake captor"
     Then the capture task should have executed

  Scenario: fuzzy match
    Given the capture task "Bakefile/we/need/to/go/deeper"
     When I execute "bake deeper"
     Then the capture task should have executed
