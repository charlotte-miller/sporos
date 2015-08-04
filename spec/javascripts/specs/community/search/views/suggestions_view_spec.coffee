describe 'CStone.Community.Search.Views', ->
  describe 'Suggestions', ->
    beforeEach =>
      @view = new CStone.Community.Search.Views.Suggestions
        session: Factory.session()


    it "renders subviews from @session", =>
      expect(@view.renderedSubViews()).toEqual undefined
      @view.render()
      expect(@view.renderedSubViews().length).toEqual 2


    it "should remove it's subviews when it is removed", =>
      @view.render()
      subviews = @view.renderedSubViews()
      subviews.forEach (subview)-> spyOn(subview, 'remove')
      @view.remove()
      subviews.forEach (subview)->
        expect(subview.remove).wasCalled()

