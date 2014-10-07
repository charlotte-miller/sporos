beforeEach ->
  jasmine.addMatchers toHaveAssociated: (expectedAssociation) ->
    @message = -> "Expected #{_(jasmine.actual).value().constructor.name} to have the association #{expectedAssociation}"
    jasmine.actual.get(expectedAssociation)?
