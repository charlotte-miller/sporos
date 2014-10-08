describe "Community.Search.Collections", ->

  describe "Results", ->
    @results = Factory.results()

    it "should build from factory", =>
      expect(@results).toBeA(Community.Search.Collections.Results)
      expect(@results.at(0)).toBeA(Community.Search.Models.Result)