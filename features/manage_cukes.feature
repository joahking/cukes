Feature: Manage cukes
  In order to use scenario outlines
  everything should work

  Scenario Outline: Testing scenario outlines
    Given there are <cuke_versions>
    Examples:
      |cuke_versions |
      |cuke_version 1|
      |cuke_version 2|
      |cuke_version 3|
      |cuke_version 4|
