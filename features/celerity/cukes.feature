Feature: In order to get Cucumber running Celerity and Webrat
   together this feature should pass

  Scenario: An ajax link is clicked
    Given I go to cukes page
    When I follow "ajax link"
    Then I should see "ajaxed cukes"

