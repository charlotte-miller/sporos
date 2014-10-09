describe "CStone.Community.Search.Models", ->

  describe "Source", ->
    @source = Factory.source()

    it "should build from factory", =>
      expect(@source).toBeA( CStone.Community.Search.Models.AbstractSource )
      # expect(@source).toHaveAssociated('examples')

    it "should have better tests", =>
      # TODO
