describe "CStone.Community.Search.Models", ->

  describe "Session", ->
    beforeEach =>
      @session = Factory.session()

    it "should build from factory", =>
      expect(@session).toBeA( CStone.Community.Search.Models.Session )
      expect(@session).toHaveAssociated('results')
      expect(@session).toHaveAssociated('sources')

    describe 'EVENTS', =>
      it "searches it's sources when the :current_search is changed", =>
        spyOn(@session.get('sources'), 'search')
        @session.set(current_search:'foo')
        expect(@session.get('sources').search).toHaveBeenCalled()
        expect(@session.get('sources').search.mostRecentCall.args).toEqual ['foo']
      
    
    describe '#state()', =>
      it "returns 'pre-search' when nothing is currently being searched", =>
        @session.set current_search: ''
        expect(@session.state()).toEqual 'pre-search'
      
      it "returns 'searching' when something is being searched and there are results", =>
        @session.set current_search: 'dog'
        expect(@session.state()).toEqual 'searching'
      
      it "returns 'no-results' when something is being searched but there are NO results", =>
        @session.set current_search: 'dog'
        @session.get('results').reset()
        expect(@session.state()).toEqual 'no-results'