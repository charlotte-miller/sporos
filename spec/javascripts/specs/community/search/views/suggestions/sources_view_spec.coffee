describe "CStone.Community.Search.Views", ->
  describe "SuggestionsSources", ->
    
    beforeEach =>
      @session = Factory.session(sources: [Factory.source()] )
      @view = new CStone.Community.Search.Views.SuggestionsSources( session: @session )
      @view.render()
      @first_source = @view.collection.first()
    
    it "has a Sources collection", =>
      expect(@view.collection).toEqual @session.get('sources')
    