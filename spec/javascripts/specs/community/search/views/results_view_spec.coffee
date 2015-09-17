# MIGRATE TO REACT.JS

# describe "CStone.Community.Search.Views", ->
#   describe "SuggestionsResults", ->
#
#     beforeEach =>
#       @session = Factory.session(results: [Factory.result()] )
#       @view = new CStone.Community.Search.Views.SuggestionsResults( session: @session )
#       @view.render()
#       @first_result = @view.collection.first()
#       spyOn(@first_result, 'open')
#
#     it "has a Results collection", =>
#       expect(@view.collection).toEqual @session.get('results')
#
#     describe 'EVENTS', =>
#       describe 'click', =>
#         it "accepts the hint", =>
#           spyOn(@session, 'acceptHint')
#           @view.$('.suggestion').click()
#           expect(@session.acceptHint).toHaveBeenCalled()
#           expect(@session.acceptHint.callCount).toEqual(1)
#
#         it "opens the result", =>
#           @view.$('.suggestion').click()
#           expect(@first_result.open).toHaveBeenCalled()
#           expect(@first_result.open.callCount).toEqual(1)
#
#       describe 'mouseover', =>
#         it "focuses the result", =>
#           @collection = @view.collection
#           spyOn(@collection, 'updateFocus')
#           @view.$('.suggestion').trigger('mouseover')
#           expect(@collection.updateFocus).toHaveBeenCalledWith(@first_result)
#           expect(@collection.updateFocus.callCount).toEqual(1)
