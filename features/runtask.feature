Feature: running tasks
  In order to run defined tasks
  I want to execute commands

  Scenario: captured execution
      Given the capture task "Bakefile/task"
       When I execute "bake task"
       Then the capture task should have executed
        And I see on stdout "Baking 'task'"

  Scenario: no arguments with no {default} task
      Given the task "Bakefile/task"
       When I execute "bake"
       Then I see on stderr "-bake: {default}: not defined"
        And I see on stdout "task"

  Scenario: {default} task
      Given the capture task "Bakefile/{default}"
       When I execute "bake"
       Then the capture task should have executed
        And I see on stdout "Baking '{default}'"

  Scenario: directory execution
      Given the capture task "Bakefile/dir/{default}"
       When I execute "bake dir"
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
            $BAKE captor
            """
       When I execute "bake initiator"
       Then the capture task should have executed
        And I see on stdout:
            """
            Baking 'initiator'
            Baking 'captor'
            """

  Scenario: fuzzy match
      Given the capture task "Bakefile/we/need/to/go/deeper"
       When I execute "bake deeper"
       Then the capture task should have executed
        And I see on stdout "Baking 'we/need/to/go/deeper'"

  Scenario: ambiguous match
      Given the task "Bakefile/first/ambi"
        And the task "Bakefile/next/ambi"
       When I execute "bake ambi"
       Then I get the error "-bake: ambi: ambiguous command"
