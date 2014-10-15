describe "CStone.Community.Search.Models", ->

  describe "AbstractSource", ->
    @source = Factory.source()

    it "should build from factory", =>
      expect(@source).toBeA( CStone.Community.Search.Models.AbstractSource )

    
    describe '#search(query)', =>
      