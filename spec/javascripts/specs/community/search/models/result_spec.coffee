describe "CStone.Community.Search.Models", ->

  describe "Result", ->
    @result = Factory.result()

    it "should build from factory", =>
      expect(@result).toBeA( CStone.Community.Search.Models.Result )
      # expect(@result).toHaveAssociated('examples')

    it "should have better tests", =>
      # TODO
