Feature: Discover completions config script in installed RubyGems
  In order to minimize cost of using completions
  As a user of RubyGems that contain completions config scripts
  I want RubyGems executables to be automatically enabled with auto-completions for my shell
  
  Scenario: Find and add completions for rubygems' executables
    Given a user's RubyGems gem cache
    And a RubyGem 'my_app' with executable 'test_app' with autocompletions
    When run local executable 'install_tabtab' with arguments ''
    Then home file '.tabtab.bash' is created
    Then gem completions are ready to be installed for applications test_app in gem my_app
  
  Scenario: Activate auto-completions for gem-based app, determine options and return all
    Given a user's RubyGems gem cache
    And a RubyGem 'my_app' with executable 'test_app' with autocompletions
    When run local executable 'tabtab' with arguments '--gem my_app test_app "" test_app'
    Then I should see a full list of options for 'test_app'

  Scenario: Activate auto-completions for gem-based app, determine partial options and return all
    Given a user's RubyGems gem cache
    And a RubyGem 'my_app' with executable 'test_app' with autocompletions
    When run local executable 'tabtab' with arguments '--gem my_app test_app -- test_app'
    Then I should not see any short form flags


