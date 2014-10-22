describe "CStone.Community.Search.Views", ->
  describe "SuggestionsResults", ->
    CStone.Community.Search.results = Factory.results()
    
    beforeEach =>
      @view = new CStone.Community.Search.Views.SuggestionsResults
        collection: CStone.Community.Search.results
        
    describe '#state()', =>
      stubCurrentSearch = (val)=>
        @view.parent_view = {parent_view:{current_search:val}}
    
      it "returns 'pre-search' when nothing is currently being searched", =>
        stubCurrentSearch('')
        expect(@view.state()).toEqual 'pre-search'
      
      it "returns 'searching' when something is being searched and there are results", =>
        stubCurrentSearch('foo')
        expect(@view.state()).toEqual 'searching'
      
      it "returns 'no-results' when something is being searched but there are NO results", =>
        stubCurrentSearch('foo')
        @view.collection.reset()
        expect(@view.state()).toEqual 'no-results'
      