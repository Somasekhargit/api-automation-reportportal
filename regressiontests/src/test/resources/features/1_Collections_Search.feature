Feature: Verify museum collection API search functionalities

  Scenario Outline: Verify number of items returned in search for default search criteria <scenario>

    Given url host
    And path <path>
    And param key = apikey
    And param q = <place>
    When method get
    Then status 200

    And match each response.artObjects[*].productionPlaces contains <place>

    * def items_returned = $..objectNumber
    * def itmes_size = items_returned.length

    Then match itmes_size == <itmes_size>

    Examples:
      | scenario  |  place     | itmes_size | path      |
      | 'nl_json' | 'Utrecht'  |    10      | path      |
      | 'en_json' | 'Utrecht'  |    10      | path_en   |


  Scenario: Verify number of items returned in search when no api key is provided

    Given url host
    And path path
    When method get
    Then status 401
    And match response == 'Invalid key'


  Scenario Outline: Verify number of items returned in default search for xml format <scenario>

    Given url host
    And path <path>
    And param key = apikey
    And param q = <place>
    And param format = <format>
    When method get
    Then status 200

    * def items_returned = $response/searchGetResponse/ArtObjects/ObjectNumber
    * def itmes_size = items_returned.length

    * def places = $response/searchGetResponse/ArtObjects/ProductionPlaces

    Then match itmes_size == <itmes_size>
    And match each places contains <place>

    Examples:
      | scenario  |  place     | itmes_size | path      |format  |
      | 'nl_xml'  |'Utrecht'   |    10      | path      | 'xml'  |
      | 'en_xml'  |'Utrecht'   |    10      | path_en   | 'xml'  |


  Scenario Outline: Verify search results in xml format for <objectNumber>

    Given url host
    And path path_en
    And param q = <objectNumber>
    And param key = apikey
    And param format = 'xml'
    When method get
    Then status 200

    * def ObjectNumber = $response/searchGetResponse/ArtObjects/ObjectNumber
    * def title = $response/searchGetResponse/ArtObjects/Title

    And match ObjectNumber == <objectNumber>
    And match title == <title>

    Examples:
      | objectNumber      | title                                |
      | 'SK-C-5'          | 'The Night Watch'                    |
      | 'RP-T-1901-A-4530'| 'Raising of the Daughter of Jairus'  |

  Scenario Outline: Verify search functionality for museum collection API with single filter criteria <scenario>

    Given url host
    And path path
    And param key = apikey
    And param involvedMaker = <involved_Maker>
    When method get
    Then status 200

    And match response.artObjects[0].principalOrFirstMaker == <involved_Maker>

    Examples:
    |scenario                 |  involved_Maker      |
    |Search_involved_Maker_1  | 'Rembrandt van Rijn' |
    |Search_involved_Maker_2  | 'Joachim Bueckelaer' |

  Scenario Outline: Verify search functionality for museum collection API with multiple filter criteria <scenario>

    Given url host
    And path path
    And param key = apikey
    And param involvedMaker = <involvedMaker>
    And param place = <place>

    When method get
    Then status 200
    And match response.artObjects[0].principalOrFirstMaker == <involvedMaker>
    And match response.artObjects[0].productionPlaces == [<place>]

    Examples:
      |scenario                      | involvedMaker        |  place        |
      |Search_involved_Maker_place   | 'Rembrandt van Rijn' | 'Amsterdam'   |

  Scenario Outline: Verify the museum collection API search results returned with query string <scenario>

    Given url host
    And path path
    And param key = apikey
    And param q = <query_string>

    When method get
    Then status 200

    And match each response.artObjects[*].title contains <query_string>

    * def items_returned = $..objectNumber
    * def itmes_size = items_returned.length

    Then match itmes_size == <itmes_size>

    Examples:
      |scenario   | query_string |  itmes_size |
      |q_Bantam   | 'Bantam'     |  10         |
      |q_Mersch   | 'Mersch'     |  10         |

  Scenario Outline: Verify number of items returned in search for custom size <scenario>

    Given url host
    And path path
    And param key = apikey
    And param place = <place>
    And param ps = <itmes_size>

    When method get
    Then status 200
    And match each response.artObjects[*].productionPlaces contains <place>

    * def items_returned = $..objectNumber
    * def itmes_size = items_returned.length

    Then match itmes_size == <expected_itmes_size>

    Examples:
      |   scenario             |  involvedMaker       |  place        | itmes_size | expected_itmes_size|
      | custom item size_100   | 'Rembrandt van Rijn' | 'Amsterdam'   |    100     |     100            |
      | custom item size_101   | 'Rembrandt van Rijn' | 'Amsterdam'   |    101     |     100            |
      | custom item size_86    | 'Rembrandt van Rijn' | 'Amsterdam'   |    86      |      90            |


  Scenario Outline: Verify number of items returned in search for custom size and page number <scenario>

    Given url host
    And path path
    And param key = apikey
    And param place = <place>
    And param ps = <itmes_size>
    And param p = <page_num>

    When method get
    Then status 200
    And match each response.artObjects[*].productionPlaces contains <place>

    * def items_returned = $..objectNumber
    * def itmes_size = items_returned.length

    And match itmes_size == <expected_itmes_size>

    Examples:
      |   scenario             |  place        | itmes_size |  page_num  | expected_itmes_size |
      | custom item size_100   | 'Amsterdam'   |    100     |     2      |     100             |
      | custom item size_101   | 'Amsterdam'   |    50      |     4      |      50             |

  Scenario Outline: Verify number of items returned in search when custom size is more than 10000 <scenario>

    Given url host
    And path path
    And param key = apikey
    And param involvedMaker = <involvedMaker>
    And param place = <place>
    And param ps = <itmes_size>
    And param p = <page_num>

    When method get
    Then status 200

    * def items_returned = $..objectNumber
    * def itmes_size = items_returned.length

    And match itmes_size == <expected_itmes_size>

    Examples:
      |   scenario             |  involvedMaker       |  place        | itmes_size |  page_num  | expected_itmes_size |
      | 'p * ps exceed 10,000' | 'Rembrandt van Rijn' | 'Amsterdam'   |    100     |     11     |      0              |


  Scenario Outline: Verify search results returned in sorting order based on <scenario>

    Given url host
    And path path
    And param key = apikey
    And param involvedMaker = 'Rembrandt van Rijn'
    And param s = <sortorder>
    And param ps = 20

    When method get
    Then status 200
    And match response.artObjects[0].principalOrFirstMaker == '#string'

    * def items_returned = $..objectNumber
    * def itmes_size = items_returned.length

    And match itmes_size == <expected_itmes_size>

    Examples:
      |   scenario   |  sortorder     | expected_itmes_size  |
      | relevance    | 'relevance'    |  20                  |
      | objecttype   | 'objecttype'   |  20                  |
      | chronologic  | 'chronologic'  |  20                  |
      | achronologic | 'achronologic' |  20                  |
      | artistdesc   | 'artistdesc'   |  20                  |


  Scenario Outline: Verify the search results displayed for facets dating period <scenario>

    Given url host
    And path path
    And param key = apikey
    And param <facetname> = <facetvalue>

    When method get
    Then status 200

    * def long_Title = response.artObjects[0].longTitle
    * def datingyear = long_Title.slice(-4)
    * def dating_cen = datingyear.slice(0,2)

    And match dating_cen == <expected_dating_cen>

    Examples:
      |   scenario                      |  facetname        |  facetvalue | expected_dating_cen |
      | 'facetsearch_dating_period_16   |   f.dating.period |     16      |     '15'            |
      | 'facetsearch_dating_period_20   |   f.dating.period |     20      |     '19'            |

  Scenario Outline: Verify the search results displayed for facets normalized32Colors <scenario>

    Given url <url>
    When method get
    Then status 200

    And match response.artObjects[0].principalOrFirstMaker == '#string'

    * def items_returned = $..objectNumber
    * def itmes_size = items_returned.length

    And match itmes_size == <expected_itmes_size>

    Examples:
      |   scenario                         |  expected_itmes_size | url                                                                                          |
      | 'facetsearch_normalized32Colors_1' |  10                  | 'https://www.rijksmuseum.nl/api/nl/collection?key=0fiuZFh4&f.normalized32Colors.hex=#4279DB' |
      | 'facetsearch_normalized32Colors_2' |  10                  | 'https://www.rijksmuseum.nl/api/nl/collection?key=0fiuZFh4&f.normalized32Colors.hex=#E09714' |

