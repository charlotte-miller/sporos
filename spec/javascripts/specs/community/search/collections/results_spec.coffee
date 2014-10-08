describe "CStone.Community.Search.Collections", ->

  describe "Results", ->
    @results = Factory.results()

    it "should build from factory", =>
      expect(@results).toBeA(CStone.Community.Search.Collections.Results)
      expect(@results.at(0)).toBeA(CStone.Community.Search.Models.Result)