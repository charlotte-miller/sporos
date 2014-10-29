describe "CStone.Community.Search.Models", ->

  describe "AbstractSource", ->
    @source = Factory.source_from_session()

    it "should build from factory", =>
      expect(@source).toBeA( CStone.Community.Search.Models.AbstractSource )
      expect(@source).toHaveAssociated('session')

    
    describe '#search(query)', =>
      