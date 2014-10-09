describe "CStone.Community.Search.Views", ->
  describe "UI", ->
    CStone.Community.Search.sources = Factory.sources()
    CStone.Community.Search.results = Factory.results()
    
    beforeEach =>
      fixture.load('main.html')
      @view = new CStone.Community.Search.Views.UI( el:'#global-search' )
    
    
    describe "@dropdown", =>
      it "is a CStone.Community.Search.Views.Suggestions", =>
        expect(@view.dropdown).toBeA CStone.Community.Search.Views.Suggestions
        expect(@view.dropdown.collection).toEqual CStone.Community.Search.results
        expect(@view.dropdown.sources_collection).toEqual CStone.Community.Search.sources
        expect(@view.dropdown.parent_ui).toEqual @view
      
      describe "when it's closed", =>
        it "renders when .text is FOCUSED", =>
          spyOn(@view.dropdown, "render")
          $('.text').trigger('focus')
          expect(@view.dropdown.render).toHaveBeenCalled()
          expect(@view.dropdown.render.callCount).toEqual 1
      
        it "renders when .search-button is first CLICKED", =>
          spyOn(@view.dropdown, "render")
          $('.search-button').trigger('click')
          expect(@view.dropdown.render).toHaveBeenCalled()
          expect(@view.dropdown.render.callCount).toEqual 1
      
      describe "when it's already open", =>
        beforeEach =>
          @view.dropdown.isVisible = true
        
        it "removes when .search-button is CLICKED", =>
          spyOn(@view.dropdown, "remove")
          $('.search-button').trigger('click')
          expect(@view.dropdown.remove).toHaveBeenCalled()
          expect(@view.dropdown.remove.callCount).toEqual 1
        
        xit "selects the focused suggestion on SUBMIT", =>
          @dropdown
        