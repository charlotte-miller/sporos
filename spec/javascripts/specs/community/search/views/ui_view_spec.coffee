describe "CStone.Community.Search.Views", ->
  describe "UI", ->
    CStone.Community.Search.session = Factory.session()
    
    beforeEach =>
      fixture.load('search')
      @view = new CStone.Community.Search.Views.UI( el:'#global-search' )
      # @clock = sinon.useFakeTimers()
    
    afterEach =>
      # @clock.restore()
    
    
    describe "Dropdown", =>
      beforeEach =>
        @dropdown = @view.dropdown
        @session = @view.session
      
      it "is a CStone.Community.Search.Views.Suggestions", =>
        expect(@dropdown).toBeA CStone.Community.Search.Views.Suggestions
        expect(@dropdown.collection).toEqual CStone.Community.Search.session.get('results')
        expect(@dropdown.sources_collection).toEqual CStone.Community.Search.session.get('sources')
        expect(@dropdown.parent_view).toEqual @view
      
      describe "CLOSED", =>
        describe "Input Control Gains Focus", =>  #transient
          beforeEach =>
            spyOn(@session, "set")
          
          it "opens when .text is FOCUSED", =>
            $('.text').trigger('focus')
            expect(@session.set).toHaveBeenCalledWith({dropdown_visible:true})
            expect(@session.set.callCount).toEqual 1
    
          it "opens when .search-button is CLICKED", =>
            $('.search-button').trigger('click')
            expect(@session.set).toHaveBeenCalledWith('dropdown_visible', true)
            expect(@session.set.callCount).toEqual 1
                           
      
      describe "OPEN", =>
        beforeEach =>
          @view._openDropdown()
          @$input = $('.text')
        
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
          beforeEach =>
            spyOn(@session, 'set')
          
          it "updates @session.current_search w/ the input value", =>
            "dog".split('').forEach (letter)->
              $('.text').val($('.text').val()+letter)
              $('.text').trigger('keyup')
            expect(@session.set.callCount).toEqual 3
            ['d', 'do', 'dog'].forEach (term)=>
              expect(@session.set).toHaveBeenCalledWith({current_search:term})
        
      
        describe "Up Arrow is Keyed", =>
          it "move dropdown menu cursor up 1 suggestion", =>
            spyOn(@dropdown.collection, 'moveFocus')
            $('.text').simulateKey('up_arrow')
            expect(@dropdown.collection.moveFocus).toHaveBeenCalled()
            expect(@dropdown.collection.moveFocus.mostRecentCall.args).toEqual ['up']
            
        
        describe "Down Arrow is Keyed", =>
          it "move dropdown menu cursor down 1 suggestion", =>
            spyOn(@dropdown.collection, 'moveFocus')
            $('.text').simulateKey('down_arrow')
            expect(@dropdown.collection.moveFocus).toHaveBeenCalled()
            expect(@dropdown.collection.moveFocus.mostRecentCall.args).toEqual ['down']
           
        describe "Right Arrow is Keyed", =>
          it "accepts the hinted suggestion", =>
            @$input.val('123')
            @view.session.currentHint = -> '12345'
            expect(@$input.cursorPosition()).toEqual 3
            @$input.simulateKey('right_arrow')
            expect(@$input.cursorPosition()).toEqual 5
          
        describe "Tab is Keyed", =>
          it "accepts the hinted suggestion", =>
            @$input.val('123')
            @view.session.currentHint = -> '12345'
            expect(@$input.cursorPosition()).toEqual 3
            @$input.simulateKey('tab')
            expect(@$input.cursorPosition()).toEqual 5
            
        describe "Enter is Keyed", =>
          beforeEach =>
            @target_model = Factory.result()
            spyOn(@target_model, 'open')
            @view.dropdown = collection: currentFocus: => @target_model
          
          it "accepts the hinted suggestion", =>
            @$input.val('123')
            @view.session.currentHint = -> '12345'
            expect(@$input.cursorPosition()).toEqual 3
            @$input.simulateKey('enter')
            expect(@$input.cursorPosition()).toEqual 5
          
          it "opens the result", =>
            @$input.simulateKey('enter')
            expect(@target_model.open).toHaveBeenCalled()
            
          
          
        describe "Esc is Keyed", =>
          beforeEach =>
            @$hint = $('.search-hint')
            @$input.val('Men')
            @$hint.val("Men's Ministry")
            
          
          it "hides the dropdown", =>
            expect(@dropdown.isVisible).toBeTruthy()
            @$input.simulateKey('escape')
            expect(@dropdown.isVisible).toBeFalsy()
            
          it "clears the hint", =>
            expect(@$hint.val()).toEqual "Men's Ministry"
            @$input.simulateKey('escape')
            expect(@$hint.val()).toEqual ''
          
          
          
        describe 'Backspace is Keyed', =>
          beforeEach =>
            @view.session.set(hint_visible:true)
            spyOn(@view, '_updateHint')
          
          it "behaves naturally when the cursor is at the end", =>
            @$input.val('123')
            @$input.simulateKey('backspace')
            expect(@view._updateHint).not.toHaveBeenCalled()
          
          it "clears the hint when the cursor is NOT at the end", =>
            @$input.val('123')
            @$input[0].setSelectionRange 1,1 #put cursor in middle
            @$input.simulateKey('backspace')
            expect(@view._updateHint).toHaveBeenCalled()
            expect(@view.session.get('hint_visible')).toBeFalsy()
          
          it "clears the hint when there is no more search term", =>
            @$input.val('')
            @$input.simulateKey('backspace')
            expect(@view._updateHint).toHaveBeenCalled()
            expect(@view.session.get('hint_visible')).toBeFalsy()
        
        describe "Suggestion is Clicked", =>
          xit "opens the result", =>
            spyOn(@target_result, 'open')
            
                