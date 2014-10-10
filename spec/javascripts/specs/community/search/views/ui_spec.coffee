describe "CStone.Community.Search.Views", ->
  describe "UI", ->
    CStone.Community.Search.sources = Factory.sources()
    CStone.Community.Search.results = Factory.results()
    
    beforeEach =>
      fixture.load('main.html')
      @view = new CStone.Community.Search.Views.UI( el:'#global-search' )
      
    
    describe "Dropdown", =>
      beforeEach =>
        @dropdown = @view.dropdown
      
      it "is a CStone.Community.Search.Views.Suggestions", =>
        expect(@dropdown).toBeA CStone.Community.Search.Views.Suggestions
        expect(@dropdown.collection).toEqual CStone.Community.Search.results
        expect(@dropdown.sources_collection).toEqual CStone.Community.Search.sources
        expect(@dropdown.parent_ui).toEqual @view
      
      describe "CLOSED", =>
        describe "Input Control Gains Focus", =>
          it "opens when .text is FOCUSED", =>
            spyOn(@dropdown, "show")
            $('.text').trigger('focus')
            expect(@dropdown.show).toHaveBeenCalled()
            expect(@dropdown.show.callCount).toEqual 1
      
          it "opens when .search-button is CLICKED", =>
            spyOn(@dropdown, "show")
            $('.search-button').trigger('click')
            expect(@dropdown.show).toHaveBeenCalled()
            expect(@dropdown.show.callCount).toEqual 1
        
        describe "Entering Text Into the Search Box", =>
          it "searches the @sources_collection w/ the input value", =>
            spyOn(@view.sources_collection, 'search')
            "dog".split('').forEach (letter)->
              $('.text').val($('.text').val()+letter)
              $('.text').trigger('keydown')
            expect(@view.sources_collection.search).toHaveBeenCalled()
            expect(@view.sources_collection.search.callCount).toEqual 3
            expect(@view.sources_collection.search.mostRecentCall.args).toEqual ['dog']
        
          it "it ignores identical searches", =>
            spyOn(@view.sources_collection, 'search')
            $('.text').val('dog')
            _(3).times -> $('.text').trigger('keydown')
            expect(@view.sources_collection.search).toHaveBeenCalled()
            expect(@view.sources_collection.search.callCount).toEqual 1
            expect(@view.sources_collection.search.mostRecentCall.args).toEqual ['dog']
          
        describe "Up Arrow is Keyed", =>
          it "move dropdown menu cursor up 1 suggestion", =>
            spyOn(@dropdown.collection, 'moveFocus')
            $('.text').simulateKey('up_arrow')
            expect(@dropdown.collection.moveFocus).toHaveBeenCalled()
            expect(@dropdown.collection.moveFocus.mostRecentCall.args).toEqual 'up'
            
        
        describe "Down Arrow is Keyed", =>
          it "move dropdown menu cursor down 1 suggestion", =>
            spyOn(@dropdown.collection, 'moveFocus')
            $('.text').simulateKey('down_arrow')
            expect(@dropdown.collection.moveFocus).toHaveBeenCalled()
            expect(@dropdown.collection.moveFocus.mostRecentCall.args).toEqual 'down'
          
          
        describe "Left Arrow is Keyed", =>
          
        describe "Right Arrow is Keyed", =>
          
        describe "Tab is Keyed", =>
          
        describe "Enter is Keyed", =>
          
        describe "Esc is Keyed", =>
          
        describe "Suggestion is Clicked", =>
          
        
      
      describe "OPEN", =>
        beforeEach =>
          @dropdown.show()
        
        describe "Input Control Loses Focus", =>          
          it "closes when .search-button (X icon) is CLICKED", =>
            spyOn(@dropdown, "hide")
            $('.search-button').trigger('click')
            expect(@dropdown.hide).toHaveBeenCalled()
            expect(@dropdown.hide.callCount).toEqual 1
        
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
              $('.text').trigger('keydown')
            expect(@view.sources_collection.search).toHaveBeenCalled()
            expect(@view.sources_collection.search.callCount).toEqual 3
            expect(@view.sources_collection.search.mostRecentCall.args).toEqual ['dog']
        
          it "it ignores identical searches", =>
            spyOn(@view.sources_collection, 'search')
            $('.text').val('dog')
            _(3).times -> $('.text').trigger('keydown')
            expect(@view.sources_collection.search).toHaveBeenCalled()
            expect(@view.sources_collection.search.callCount).toEqual 1
            expect(@view.sources_collection.search.mostRecentCall.args).toEqual ['dog']
      
        describe "Down Arrow is Keyed", =>
          
        describe "Left Arrow is Keyed", =>
          
        describe "Right Arrow is Keyed", =>
          
        describe "Tab is Keyed", =>
          
        describe "Enter is Keyed", =>
          
        describe "Esc is Keyed", =>
          
        describe "Suggestion is Clicked", =>
          