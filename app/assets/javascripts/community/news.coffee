class CStone.Community.News

  class Feed
    constructor: (container, item)->
      @isotope = new Isotope container,
        itemSelector: item
        layoutMode: 'masonry'

    # Handle Image Hight Adjustments
    reflow: (isoInstance, laidOutItems) =>
      setTimeout =>
        @isotope.off 'layoutComplete', @reflow
        @isotope.arrange({})
        @isotope.on 'layoutComplete', @reflow
      , 1500

    filter: (filter_str)=>
      @isotope.arrange({filter: filter_str})
  
  
  # CStone.Community.News.feed
  @feed: 'CStone.Community.News not initialized'
  @init: =>
    @initalized = true
    if document.getElementById('cards')
      @feed = new Feed('#cards', '.card')
      @feed.isotope.on 'layoutComplete', @feed.reflow
      @feed.reflow()
    
    # Initialize Jquery
    $ ->
      $("#cards img").unveil 300, '#main-page'

      $('.ministry').click (e)->
        e.preventDefault()

        # Update Tabs
        $('#community-feed > ul > li.active').removeClass('active')
        $tab = $(@).parent()
        $tab.addClass('active')

        # Filter Cards
        ministry = $tab.attr('id').replace('-link','')
        filter = '*'                         if ministry == 'all'
        filter = '.men, .women, .rendezvous' if ministry == 'adults'
        filter ||= ".#{ministry}"
        $("#{filter} img").trigger('unveil') unless filter=='*'
        CStone.Community.News.feed.filter(filter)

