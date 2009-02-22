Feature: In order to get Cucumber running Celerity and Webrat
   together this feature should pass

  Scenario: A non ajax link is clicked
    Given I go to cukes page
    When I follow "webrat link"
    Then I should see "Cukes dashboard"
