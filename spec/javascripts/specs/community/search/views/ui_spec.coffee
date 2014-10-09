describe "CStone.Community.Search.Views", ->
  describe "UI", ->
    CStone.Community.Search.sources = Factory.sources()
    CStone.Community.Search.results = Factory.results()
    
    beforeEach =>
      fixture.load('main.html')
      @view = new CStone.Community.Search.Views.UI( el:'#global-search' )
    
    
    describe "Open/Close Dropdown", =>
      it "is a CStone.Community.Search.Views.Suggestions", =>
        expect(@view.dropdown).toBeA CStone.Community.Search.Views.Suggestions
        expect(@view.dropdown.collection).toEqual CStone.Community.Search.results
        expect(@view.dropdown.sources_collection).toEqual CStone.Community.Search.sources
        expect(@view.dropdown.parent_ui).toEqual @view
      
      describe "when it's CLOSED", =>
        it "opens when .text is FOCUSED", =>
          spyOn(@view.dropdown, "render")
          $('.text').trigger('focus')
          expect(@view.dropdown.render).toHaveBeenCalled()
          expect(@view.dropdown.render.callCount).toEqual 1
      
        it "opens when .search-button is first CLICKED", =>
          spyOn(@view.dropdown, "render")
          $('.search-button').trigger('click')
          expect(@view.dropdown.render).toHaveBeenCalled()
          expect(@view.dropdown.render.callCount).toEqual 1
      
      describe "when it's already OPEN", =>
        beforeEach =>
          @view.dropdown.show()
        
        it "closes when .search-button is CLICKED", =>
          spyOn(@view.dropdown, "remove")
          $('.search-button').trigger('click')
          expect(@view.dropdown.remove).toHaveBeenCalled()
          expect(@view.dropdown.remove.callCount).toEqual 1
        
        xit "selects the focused suggestion on SUBMIT", =>
          @view

        xit "closes on SUBMIT", =>
          @view
        
        xit "closes when you scroll away", =>
          @view
        
        xit "closes when you click outside of the UI", =>
          @view
          
        
    
    describe "Entering Text Into the Search Box", =>
      it "searches the @sources_collection w/ the input value", =>
        spyOn(@view.sources_collection, 'search')
        "dog".split('').forEach (letter)->
          $('.text').val($('.text').val()+letter)
          $('.text').trigger('keyup')
        expect(@view.sources_collection.search).toHaveBeenCalled()
        expect(@view.sources_collection.search.callCount).toEqual 3
        expect(@view.sources_collection.search.mostRecentCall.args).toEqual ['dog']
        
      it "it ignores identical searches", =>
        spyOn(@view.sources_collection, 'search')
        $('.text').val('dog')
        _(3).times -> $('.text').trigger('keyup')
        expect(@view.sources_collection.search).toHaveBeenCalled()
        expect(@view.sources_collection.search.callCount).toEqual 1
        expect(@view.sources_collection.search.mostRecentCall.args).toEqual ['dog']
      
    
    
    describe "Up Arrow is Keyed", ->
      
    describe "Down Arrow is Keyed", ->
      
    describe "Left Arrow is Keyed", ->
      
    describe "Right Arrow is Keyed", ->
      
    describe "Tab is Keyed", ->
      
    describe "Enter is Keyed", ->
      
    describe "Esc is Keyed", ->
      
    describe "Suggestion is Clicked", ->
      