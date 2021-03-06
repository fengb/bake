Feature: executing tasks
  In order to use defined tasks
  I want to actually execute them

  Scenario: no Bakefile
       When I execute "bake"
       Then I see on stderr "-bake: no Bakefile found"

  Scenario: captured execution
      Given the capture task "Bakefile/task"
       When I execute "bake task"
       Then the capture task should have executed
        And I see on stdout "Baking 'task'"

  Scenario: captured execution suppressing status
      Given the capture task "Bakefile/task"
       When I execute "bake -s task"
       Then the capture task should have executed
        And I see on stdout ""

  Scenario: no arguments with no {default} task
      Given the task "Bakefile/task"
       When I execute "bake"
       Then I see on stderr "-bake: {default}: task not defined"
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
      Given the directory "Bakefile"
       When I execute "bake nonexistent"
       Then I get the error "-bake: nonexistent: task does not exist"

  Scenario: attempted execution of non executable
      Given the file "Bakefile/file"
       When I execute "bake file"
       Then I get the error "-bake: file: task not executable"

  Scenario: bakeception
      Given the tasks:
            | Bakefile/initiator | $BAKE captor |
            | Bakefile/captor    | ==capture==  |
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

  Scenario: fuzzy match {default} task
      Given the capture task "Bakefile/we/need/to/go/deeper/{default}"
       When I execute "bake deeper"
       Then the capture task should have executed
        And I see on stdout "Baking 'we/need/to/go/deeper'"

  Scenario: ambiguous match
      Given the tasks:
            | Bakefile/first/ambi |
            | Bakefile/next/ambi  |
       When I execute "bake ambi"
       Then I get the error "-bake: ambi: task ambiguous"
