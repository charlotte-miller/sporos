#= require_tree ./specs

describe "Working Specs", ->
  beforeEach ->
    jasmine.getFixtures().fixturesPath = '/spec/javascripts/fixtures'
    loadFixtures('headroom.html','main.html')
    # CStone.Community.Search.init()
  
  
  it "should know truth", ->
    expect(true).toBeTruthy()
    expect($('#global-search')).toContainText 'FOO'

    ###
    Fixtures don't seem to be working... they show up blank :(
    Maybe debug around the right way to loadFixtures
    ###
  