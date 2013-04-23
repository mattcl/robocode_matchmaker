Feature: Uploading a bot
  As a mentor
  I want kids to be able to upload their robocode bots
  So that they can compete against each other

  Scenario: Not logged in should be given the option to login or register
    Given I am not authenticated
    When I go to the robots page
    Then I should not see "Upload new bot"
    And I should see "Login or register to upload"
    When I click "Login or register to upload"
    Then I should be on the login page

  Scenario: Uploading a new bot
    Given I am authenticated
    When I go to the robots page
    Then I should not see "Login or register to upload"
    And I should see "Upload new bot"
    When I click "Upload new bot"
    Then I should see "Upload a new bot"
