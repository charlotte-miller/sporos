beforeEach ->
  jasmine.addMatchers toBeEmpty: ->
    jasmine.message = -> "Expected #{_(jasmine.actual).value().constructor.name} to be empty"
    _(jasmine.actual).isEmpty()
  
  jasmine.addMatchers toBeA: (expected) ->
    value = _(jasmine.actual).value()
    jasmine.message = -> "Expected #{value.constructor.name} to be a #{expected.name}"
    switch expected  # handle inconsistent instanceof interface
      when String then value.constructor.name == "String"
      when Number then value.constructor.name == "Number"
      else value instanceof expected
  
  jasmine.addMatchers toBeValid: () ->
    jasmine.message = -> "Expected #{_(jasmine.actual).value().constructor.name} to be valid"
    jasmine.actual.isValid()
  
  # Non-recursive version of toContain()
  jasmine.addMatchers toInclude: (expected) ->
    jasmine.message = -> "Expected the collection to include #{_(jasmine.actual).value().constructor.name}"
    _(jasmine.actual).include(expected)
  
