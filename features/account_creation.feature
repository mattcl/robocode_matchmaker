Feature: User account
  As a mentor
  I want kids to be able to create accounts
  So that they can upload robots
  Scenario: Creating a new account
    Given I am not authenticated
    When I go to register
    And I fill in "user_username" with "derpmaster"
    And I fill in "user_email" with "derp@derpmaster.com"
    And I fill in "user_password" with "test1234"
    And I fill in "user_password_confirmation" with "test1234"
    And I press "Sign up"
    Then I should see "Logged in as derpmaster"
