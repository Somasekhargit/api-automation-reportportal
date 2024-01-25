Feature: Verify museum collection details API search functionalities

  Scenario Outline: Verify collection object details for a objectNumber <objectNumber>

    Given url host
    And path path_en + <objectNumber>
    And param key = apikey
    When method get
    Then status 200

    And match response.artObject.objectNumber == <objectNumber>
    And match response.artObject.materials == <materials>

    Examples:
      | objectNumber      | materials                       |
      | 'SK-C-5'          | ["canvas","oil paint (paint)"]  |
      | 'RP-T-1901-A-4530'| ["paper","ink"]                 |

  Scenario: Verify collection object details when no api key is provided

    Given url host
    And path path_en + 'SK-C-5'
    When method get
    Then status 401
    And match response == 'Invalid key'

  Scenario Outline: Verify collection object details in xml format for <objectNumber>

    Given url host
    And path path_en + <objectNumber>
    And param key = apikey
    And param format = 'xml'
    When method get
    Then status 200

    * def ObjectNumber = $response/artObjectGetResponse/ArtObject/ObjectNumber
    * def materials = $response/artObjectGetResponse/ArtObject/Materials

    And match ObjectNumber == <objectNumber>
    And match materials == <materials>


    Examples:
      | objectNumber      | materials                       |
      | 'SK-C-5'          | ["canvas","oil paint (paint)"]  |
      | 'RP-T-1901-A-4530'| ["paper","ink"]                 |