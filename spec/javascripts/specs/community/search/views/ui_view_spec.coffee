describe "CStone.Community.Search.Views", ->
  describe "UI", ->
    
    beforeEach =>
      fixture.load('search')
      CStone.Community.Search.session = Factory.session()
      @view = new CStone.Community.Search.Views.UI( el:'#global-search', ui_name:'foo' )
      @clock = sinon.useFakeTimers()
    
    afterEach =>
      @clock.restore()
    
    describe "Dropdown", =>
      beforeEach =>
        @session = @view.session
        @session.set(dropdown_visible:true)
        @dropdown = @view.dropdown
      
      it "is a CStone.Community.Search.Views.Suggestions", =>
        expect(@dropdown).toBeA CStone.Community.Search.Views.Suggestions
        expect(@dropdown.collection).toEqual CStone.Community.Search.session.get('results')
        expect(@dropdown.sources_collection).toEqual CStone.Community.Search.session.get('sources')
        expect(@dropdown.parent_view).toEqual @view
      
      describe "CLOSED", =>
        beforeEach =>
          @session.set(dropdown_visible:false)
        
        describe "Input Control Gains Focus", =>
          it "opens when .text is FOCUSED", =>
            spyOn(@session, "set")
            $('.text').trigger('focus')
            expect(@session.set).toHaveBeenCalledWith({dropdown_visible:true, active_ui:'foo'})
            expect(@session.set.callCount).toEqual 1
    
          it "opens when .search-button is CLICKED", =>
            spyOn(@session, "set")
            $('.search-button').trigger('click')
            expect(@session.set).toHaveBeenCalledWith('dropdown_visible', true)
                           
          it "sets @session.get('active_ui') when .search-button is CLICKED", =>
            $('.search-button').trigger('click')
            expect(@session.get('active_ui')).toEqual('foo')
          
      
      describe "OPEN", =>
        beforeEach =>
          @$input = $('.text')
        
        describe "Input Control Loses Focus", =>
          it "closes when .search-button (X icon) is CLICKED", =>
            spyOn(@dropdown, "remove")
            $('.search-button').trigger('click')
            expect(@dropdown.remove).toHaveBeenCalled()
            expect(@dropdown.remove.callCount).toEqual 1
        
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
            "dog".split('').forEach (letter)=>
              $('.text').val($('.text').val()+letter)
              $('.text').trigger('keypress')
              @clock.tick(1)
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
            spyOn(@session, 'acceptHint')
            @$input.simulateKey('right_arrow')
            expect(@session.acceptHint).toHaveBeenCalled()
          
        describe "Tab is Keyed", =>
          it "accepts the hinted suggestion", =>
            spyOn(@session, 'acceptHint')
            @$input.simulateKey('right_arrow')
            expect(@session.acceptHint).toHaveBeenCalled()
            
        describe "Enter is Keyed", =>
          beforeEach =>
            @session.set current_search: 'men'
            @target_model = @session.get('results').first()
            @session.get('results').updateFocus(@target_model)
            spyOn(@target_model, 'open')
          
          it "accepts the hinted suggestion", =>
            @$input.simulateKey('enter')
            expect(@session.get('current_search')).toEqual "men's ministry"
            expect(@$input.cursorPosition()).toEqual 14
          
          it "opens the result", =>
            @$input.simulateKey('enter')
            expect(@target_model.open).toHaveBeenCalled()
                  
          
        describe "Esc is Keyed", =>
          beforeEach =>
            @session.set(current_search:'men')
          
          it "hides the dropdown", =>
            expect(@session.get('dropdown_visible')).toBeTruthy()
            @$input.simulateKey('escape')
            expect(@session.get('dropdown_visible')).toBeFalsy()
            
          it "clears the hint", =>
            @session.set(hint_visible:true)
            @$input.simulateKey('escape')
            expect(@session.get('hint_visible')).toBeFalsy()
          
          
          
        describe 'Backspace is Keyed', =>
          beforeEach =>
            @view.session.set(hint_visible:true)
            spyOn(@view, 'thenUpdateHint')
            @view.modelEvents() #point callback to spy
          
          it "behaves naturally when the cursor is at the end", =>
            @$input.val('123')
            @$input.simulateKey('backspace')
            @clock.tick(1)
            expect(@view.thenUpdateHint).not.toHaveBeenCalled()
          
          it "clears the hint when the cursor is NOT at the end", =>
            @$input.val('123')
            @$input[0].setSelectionRange 1,1 #put cursor in middle
            @$input.simulateKey('backspace')
            @clock.tick(1)
            expect(@view.thenUpdateHint).toHaveBeenCalled()
            expect(@view.session.get('hint_visible')).toBeFalsy()
          
          it "clears the hint when there is no more search term", =>
            @$input.val('')
            @$input.simulateKey('backspace')
            @clock.tick(1)
            expect(@view.thenUpdateHint).toHaveBeenCalled()
            expect(@view.session.get('hint_visible')).toBeFalsy()
        
        describe "Suggestion is Clicked", =>
          xit "opens the result", =>
            spyOn(@target_result, 'open')
            
                