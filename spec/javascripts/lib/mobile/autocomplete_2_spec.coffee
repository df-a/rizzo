require ['lib/mobile/autocomplete_2'], (AutoComplete) ->

  describe 'AutoComplete 2', ->

    myAutoComplete = null

    DEFAULT_CONFIG =
      id: 'my_search',
      uri: '/search/'

    SEARCH_TERM = 'London'
    TEXT_NODE = 3
    EMPTY_RESULTS = []
    SEARCH_RESULTS = [
      {
        title: "London"
        uri: "/london"
        type: "place"
      }
      {
        title: "Paris"
        uri: "/paris"
        type: "hotel"
      }
      {
        title: "Newcastle"
        uri: "/australia/newcastle"
        type: "publication"
      }
    ]
    MAPPED_RESULTS = [
      {
        name: "London"
        location: "/london"
        category: "place"
      }
      {
        name: "Paris"
        location: "/paris"
        category: "hotel"
      }
      {
        name: "Newcastle"
        location: "/australia/newcastle"
        category: "publication"
      }
    ]
    RESULT_MAP =
      title: 'name',
      uri: 'location',
      type: 'category'

    describe 'Object', ->
      it 'is defined', ->
        expect(AutoComplete).toBeDefined()

    describe 'Initialisation', ->

      describe 'checking for required arguments', ->
        beforeEach ->
          loadFixtures 'autocomplete_mobile.html'
          spyOn(AutoComplete.prototype, "_init").andCallThrough()

        it 'should initialise if required arguments are supplied', ->
          myAutoComplete = new AutoComplete DEFAULT_CONFIG

          expect(AutoComplete.prototype._init).toHaveBeenCalledWith DEFAULT_CONFIG

        it 'should not initialise if required argument element ID is not supplied', ->
          myAutoComplete = new AutoComplete {uri: '/search'}

          expect(AutoComplete.prototype._init).not.toHaveBeenCalled()

        it 'should not initialise if required argument URI is not supplied', ->
          myAutoComplete = new AutoComplete {id: 'my_search'}

          expect(AutoComplete.prototype._init).not.toHaveBeenCalled()

      describe 'configuring the component', ->
        beforeEach ->
          loadFixtures 'autocomplete_mobile.html'

        it 'should return a config object updated with the passed keys', ->
          newConfig = {id: 'my_search', uri: '/findme', parent: '.somewhere'}

          myAutoComplete = new AutoComplete newConfig
          config = myAutoComplete.config

          expect(config.id).toBe newConfig.id
          expect(config.uri).toBe newConfig.uri
          expect(config.parent).toBe newConfig.parent

      describe 'setting up the component', ->
        beforeEach ->
          loadFixtures 'autocomplete_mobile.html'

        it 'should create the list element and add it as an object property', ->
          myAutoComplete = new AutoComplete DEFAULT_CONFIG

          expect(myAutoComplete.results).toBeDefined()
          expect(myAutoComplete.results.tagName).toBe 'UL'
          expect(myAutoComplete.results.childNodes.length).toBe 0
          expect(myAutoComplete.results.className).toBe 'autocomplete__results'
          expect(myAutoComplete.results.hovered).not.toBeDefined()

        it 'should create the list element with the specified class name', ->
          newConfig = {id: 'my_search', uri: '/search', resultsClass: 'mysearch__results'}
          myAutoComplete = new AutoComplete newConfig

          expect(myAutoComplete.results).toBeDefined()
          expect(myAutoComplete.results.className).toBe newConfig.resultsClass

    describe 'the results list', ->
      beforeEach ->
        loadFixtures 'autocomplete_mobile.html'
        myAutoComplete = new AutoComplete DEFAULT_CONFIG

      it 'should add a list hovered property to the component when mouse is over results', ->
        myAutoComplete._resultsMouseOver()

        expect(myAutoComplete.results.hovered).toBe true

      it 'should remove a list hovered property from the component when mouse is removed from results', ->
        myAutoComplete._resultsMouseOver()
        myAutoComplete._resultsMouseOut()

        expect(myAutoComplete.results.hovered).not.toBeDefined()

    describe 'updating the results list', ->

      describe 'performing a search', ->

        describe 'the search threshold', ->

          describe 'the default search threshold', ->
            beforeEach ->
              loadFixtures 'autocomplete_mobile.html'
              myAutoComplete = new AutoComplete DEFAULT_CONFIG
              spyOn myAutoComplete, '_makeRequest'

            it 'should perform a search if the threshold has been reached', ->
              minimumSearch = 'abc'
              myAutoComplete._searchFor minimumSearch

              expect(myAutoComplete._makeRequest).toHaveBeenCalledWith minimumSearch

            it 'should not perform a search if the threshold has not been reached', ->
              belowMinimumSearch = 'ab'
              myAutoComplete._searchFor belowMinimumSearch

              expect(myAutoComplete._makeRequest).not.toHaveBeenCalled()

          describe 'configuring the search threshold', ->
            beforeEach ->
              loadFixtures 'autocomplete_mobile.html'
              newConfig = {id: 'my_search', uri: '/search', threshold: 5}
              myAutoComplete = new AutoComplete newConfig
              spyOn myAutoComplete, '_makeRequest'

            it 'should perfom a search if the configured threshold has been reached', ->
              minimumSearch = 'abcde'
              myAutoComplete._searchFor minimumSearch

              expect(myAutoComplete._makeRequest).toHaveBeenCalledWith minimumSearch

            it 'should not perfom a search if the configured threshold has not been reached', ->
              minimumSearch = 'abcd'
              myAutoComplete._searchFor minimumSearch

              expect(myAutoComplete._makeRequest).not.toHaveBeenCalled()

        describe 'generating the search URI', ->

          describe 'generating the default search endpoint', ->
            beforeEach ->
              loadFixtures 'autocomplete_mobile.html'
              myAutoComplete = new AutoComplete DEFAULT_CONFIG

            it 'should generate the full URI for the search endpoint with the search term', ->
              searchTerm = 'London'
              generatedURI = myAutoComplete._generateURI searchTerm

              expect(generatedURI).toBe "#{DEFAULT_CONFIG.uri}#{searchTerm}"

            it 'should generate the full URI for the search endpoint with the search term and scope', ->
              searchTerm = 'London'
              scope = 'homepage'
              generatedURI = myAutoComplete._generateURI searchTerm, scope

              expect(generatedURI).toBe "#{DEFAULT_CONFIG.uri}#{searchTerm}?scope=#{scope}"

          describe 'configuring the search endpoint', ->
            newConfig = {id: 'my_search', uri: '/mySearch='}

            beforeEach ->
              loadFixtures 'autocomplete_mobile.html'
              myAutoComplete = new AutoComplete newConfig

            it 'should generate the full URI for the search endpoint with the search term', ->
              searchTerm = 'London'
              generatedURI = myAutoComplete._generateURI searchTerm

              expect(generatedURI).toBe "#{newConfig.uri}#{searchTerm}"

            it 'should generate the full URI for the search endpoint with the search term and scope', ->
              searchTerm = 'London'
              scope = 'homepage'
              generatedURI = myAutoComplete._generateURI searchTerm, scope

              expect(generatedURI).toBe "#{newConfig.uri}#{searchTerm}?scope=#{scope}"

        describe 'search throttling', ->
          it 'should do something cool'



      describe 'adding the results list to the page', ->
        beforeEach ->
          loadFixtures 'autocomplete_mobile.html'
          myAutoComplete = new AutoComplete DEFAULT_CONFIG

          myAutoComplete._populateResults SEARCH_RESULTS, SEARCH_TERM

        it 'should append the populated list to the page', ->
          expect($('.autocomplete__results').length).toBe 1

      describe 'populating the results list', ->
        beforeEach ->
          loadFixtures 'autocomplete_mobile.html'
          myAutoComplete = new AutoComplete DEFAULT_CONFIG

        describe 'adding items to an empty list', ->
          it 'should insert a list item for each result item into the results list element', ->
            expect(myAutoComplete.results.populated).not.toBeDefined()

            myAutoComplete._populateResults SEARCH_RESULTS, SEARCH_TERM

            expect(myAutoComplete.results.populated).toBe true

            results = myAutoComplete.results.childNodes
            expect(results.length).toBe SEARCH_RESULTS.length
            expect(results[0].textContent).toBe SEARCH_RESULTS[0].title
            expect(results[1].textContent).toBe SEARCH_RESULTS[1].title
            expect(results[2].textContent).toBe SEARCH_RESULTS[2].title

        describe 'adding items to a populated list', ->
          beforeEach ->
            myAutoComplete._populateResults SEARCH_RESULTS, SEARCH_TERM
            
          it 'should remove the previous results from the list', ->
            spyOn myAutoComplete, '_emptyResults'
            myAutoComplete._populateResults SEARCH_RESULTS, SEARCH_TERM

            expect(myAutoComplete._emptyResults).toHaveBeenCalled()

          it 'should contain the new search results', ->
            newResults = [
              title: "Newcastle"
              uri: "/australia/newcastle"
              type: "publication"
            ]
            myAutoComplete._populateResults newResults, SEARCH_TERM

            results = myAutoComplete.results.childNodes

            expect(myAutoComplete.results.populated).toBe true
            expect(results.length).toBe 1

      describe 'generating a list item from a result item', ->
        item = null
        searchTerm = 'Lon'
  
        describe 'creating a text item', ->
          testingMap = 
            title: 'title'
    
          newConfig = {id: 'my_search', uri: '/search', map: testingMap}

          beforeEach ->
            loadFixtures 'autocomplete_mobile.html'
            myAutoComplete = new AutoComplete newConfig
            item = myAutoComplete._createListItem SEARCH_RESULTS[0], searchTerm

          it 'should return a list item containing the search results title', ->
            expect(item.tagName).toBe 'LI'
            expect(item.textContent).toBe SEARCH_RESULTS[0].title
            expect(item.className).toBe 'autocomplete__result'

          it 'should highlight the search term', ->
            expect(item.tagName).toBe 'LI'
            expect(item.innerHTML).toBe '<b>Lon</b>don'
        
        describe 'creating a basic link item', ->
          testingMap = 
            title: 'title',
            uri: 'uri'
    
          newConfig = {id: 'my_search', uri: '/search', map: testingMap}
    
          beforeEach ->
            loadFixtures 'autocomplete_mobile.html'
            myAutoComplete = new AutoComplete newConfig
            item = myAutoComplete._createListItem SEARCH_RESULTS[0], searchTerm

          it 'should return a list item containing an anchor tag', ->
            expect(item.tagName).toBe 'LI'
            expect(item.textContent).toBe SEARCH_RESULTS[0].title

            anchor = item.childNodes[0]
            expect(anchor.tagName).toBe 'A'
            expect(anchor.getAttribute('href')).toBe SEARCH_RESULTS[0].uri
            expect(anchor.className).toBe 'autocomplete__result__link'

          it 'should contain an anchor tag containing the highlighted search term', ->
            anchor = item.childNodes[0]

            expect(anchor.tagName).toBe 'A'
            expect(anchor.innerHTML).toBe '<b>Lon</b>don'

        describe 'creating a typed link item', ->
          testingMap = 
            title: 'title',
            uri: 'uri',
            type: 'type'
    
          newConfig = {id: 'my_search', uri: '/search', map: testingMap}
    
          beforeEach ->
            loadFixtures 'autocomplete_mobile.html'
            myAutoComplete = new AutoComplete newConfig
            item = myAutoComplete._createListItem SEARCH_RESULTS[0], searchTerm

          it 'should return a list item containing an anchor tag', ->
            expect(item.tagName).toBe 'LI'
            expect(item.textContent).toBe SEARCH_RESULTS[0].title

            anchor = item.childNodes[0]
            expect(anchor.tagName).toBe 'A'
            expect(anchor.getAttribute('href')).toBe SEARCH_RESULTS[0].uri
            expect(anchor.className).toBe 'autocomplete__result__link'

          it 'should contain an anchor tag containing the highlighted search term', ->
            anchor = item.childNodes[0]

            expect(anchor.tagName).toBe 'A'
            expect(anchor.innerHTML).toBe '<b>Lon</b>don'

      describe 'highlighting the search term', ->
        beforeEach ->
          loadFixtures 'autocomplete_mobile.html'
          myAutoComplete = new AutoComplete DEFAULT_CONFIG

        it 'should highlight the search text at the start of a title', ->
          searchTerm = 'Lond'

          highlightedText = myAutoComplete._highlightText SEARCH_RESULTS[0].title, searchTerm
          expect(highlightedText).toBe '<b>Lond</b>on'

        it 'should highlight the search text at the end of a title', ->
          searchTerm = 'don'

          highlightedText = myAutoComplete._highlightText SEARCH_RESULTS[0].title, searchTerm
          expect(highlightedText).toBe 'Lon<b>don</b>'

        it 'should highlight the search text in the middle of a title', ->
          searchTerm = 'ond'

          highlightedText = myAutoComplete._highlightText SEARCH_RESULTS[0].title, searchTerm
          expect(highlightedText).toBe 'L<b>ond</b>on'

        it 'should highlight the search text if it exactly matches a title', ->
          searchTerm = 'London'

          highlightedText = myAutoComplete._highlightText SEARCH_RESULTS[0].title, searchTerm
          expect(highlightedText).toBe '<b>London</b>'

        it 'should highlight the search text multiple times', ->
          searchTerm = 'London'
          testTitle = 'Is London really as nice as London?'

          highlightedText = myAutoComplete._highlightText testTitle, searchTerm
          expect(highlightedText).toBe 'Is <b>London</b> really as nice as <b>London</b>?'

        it 'should not highlight anything if the search text is not found', ->
          searchTerm = 'London'

          highlightedText = myAutoComplete._highlightText SEARCH_RESULTS[1].title, searchTerm
          expect(highlightedText).toBe 'Paris'
