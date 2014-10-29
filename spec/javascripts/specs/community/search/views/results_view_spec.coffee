describe "CStone.Community.Search.Views", ->
  describe "SuggestionsResults", ->
        
    beforeEach =>
      @view = new CStone.Community.Search.Views.SuggestionsResults
        collection: Factory.results()
        
      