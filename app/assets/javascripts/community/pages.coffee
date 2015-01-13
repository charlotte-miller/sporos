class CStone.Community.Pages
  # CStone.Community.Pages.layout
  @layout: 'CStone.Community.Pages not initialized'
  @init: =>
    @initalized = true
    @layout = new Layout('#main-page', '#page')
    
    # Initialize Jquery
    $ =>
      layout = @layout
      $body = $('html, body')
      
      # Rescroll on Resize && Set Inital Scroll
      reScrollLayout = ->
        if layout.$main.hasClass('current')
          $body.scrollLeft(0) #far left
        else
          $body.scrollLeft(1000000000) #far right
      $(window).resize _.throttle(reScrollLayout, 500)
      reScrollLayout()
        
      $('.home-link').click (e)->
        e.preventDefault()
        layout.loadPage $(@).prop('href')
            
      $('#main-page a').not('.ministry').click (e)->
        e.preventDefault()

        $('#headroom').removeClass('headroom--pinned')
        $('#headroom').addClass('headroom--unpinned')

        layout.loadPage $(@).prop('href'), ->
          $('.home-link').click (e)->
            e.preventDefault()
            layout.loadPage $(@).prop('href')
  
  
  
  class Layout
    constructor: (main, page, mainPath='/') ->
      @mainPath = mainPath             # The url/path to the main page
      @$main = $(main)                 # Container element for the main page
      @$page = $(page)                 # Container element content pages load into
      @cache = {}                      # Variable that stores pages after they are requested
      @href = window.location.href     # Url of the content that is currently displayed
      window.onpopstate = @onPopState  # Sets the popstate function
    
      # Sets a default state
      if history.state is null
        history.replaceState
          id: @$page.prop("id")
        , document.title, @href
    

    ###
    Loads the contents of a url into $page
    -param   {string}     url
    -param   {object}     options
      -options  {bool}    isPopped - used to determine if whe should add a new item into the history object
    -param   {function}   (url, $container, $content) ->
    ###
    loadPage: (url, options={}, callback)=>
      # Options optional
      if _(options).isFunction()
        callback = options
        options = {}
    
      # Load normally if external or #hash
      unless Layout.utility.shouldLoad(url)
        window.location = url
        return
        
      # Fetches the contents of a url and stores it in the '@cache' varible
      fetch = (url) =>
      
        if !!@$main.html()
          @cache[Layout.utility.pathToUrl(@mainPath)] ||=
            status: "loaded"
            title: document.title
            html: $("<div><p id='#{@$main.attr('id')}'>Stored in DOM</p></div>")
        
        # Don't fetch we have the content already
        unless @cache.hasOwnProperty(url)
          transitions.loading()
          @cache[url] = status: "fetching"
          request = $.ajax(url)
    
          # Store contents in @cache variable if successful
          request.success (html) =>
            # Clear @cache varible if it's getting too big
            Layout.utility.clearIfOverCapacity(@cache, 30)
            Layout.utility.storePage @cache, url, html

          # Mark as error
          request.error => @cache[url].status = "error"
          
        # Start checking for the status of content
        responses[@cache[url].status]()
    
    
      # If the content has been requested and is done:
      # Updates the contents from @cache[url]
      updateContent = (url) =>
        container = if @isMainPage(url) then @$main else @$page
        containerId = "#" + container.prop("id")
        $content = Layout.utility.getContentById(containerId, @cache[url].html)
        if $content
          document.title = @cache[url].title
          @href = url
          container.html $content  unless @isMainPage(url) && @$main.html()
        
        else
          window.location = url # No content availble to update with, aborting...

      # List of responses for the states of the page request
      responses=
        # Page is ready, update the content
        loaded: =>
          updateContent( url )
          transitions.revealing()
          unless options.isPopped
            history.pushState
              id: @$page.prop("id")
            , @cache[url].title, url
      
        # Loading, wait 10 ms and check again
        fetching: =>
          setTimeout (=>
            responses[@cache[url].status]()
          ), 10

        # Error, abort and redirect
        error: -> window.location = url
    
      $body = $("html, body")
      transitions=
        loading: =>
          @$page.trigger 'CStone.Community.Pages.Layout.loadPage.loading'
          @$main.addClass('background')
  
        revealing: =>
          @$page.trigger "CStone.Community.Pages.Layout.loadPage.revealing"
          animatePageTransition(transitions.cleanup)
  
        cleanup: =>
          @$page.trigger "CStone.Community.Pages.Layout.loadPage.cleanup"
          # remove old content etc.
          callback?()
    
      lastURL = @href
      animatePageTransition= (callback)=>
        fromMain = @isMainPage(lastURL)
        toMain   = @isMainPage(url)

        if fromMain
          if !toMain
            @$main.addClass('background')
            @$main.removeClass('current')
            @$page.addClass('current')
            callback()
      
        else #fromPage
          if toMain
            @$page.removeClass('current')
            @$main.addClass('current')
            setTimeout (=> @$main.removeClass('background')), 500
            setTimeout (=> @$page.html('')), 1000
            callback()
              
          else #toPage
            # Change #page to #page-outgoing
            # Load #page below (or above)
            # Insert and animate
          
            if options.isPopped
              # # {reverse:true, replace:true}
            else
              # {reverse:false, replace:true}
      

      ## Execute
      fetch(url)
      return @

        
    isMainPage: (href=window.location.href)=>
      $("<a href=#{href}><a>").prop('href')
      uri = new URI(href)
      uri.path == @mainPath

    # Handles the popstate event, like when the user hits 'back'
    onPopState: (e)=>
      if e.state isnt null
        url = window.location.href
        @$page = $("#" + e.state.id)
        @loadPage url, {isPopped:true}  if @href isnt url and not Layout.utility.isHash(url)

  
    # Static Utility Methods
    @utility:
      # Prevents jQuery from stripping elements from $(html)
      htmlDoc: (html) ->
        parent = undefined
        elems = $()
        matchTag = /<(\/?)(html|head|body|title|base|meta)(\s+[^>]*)?>/g
        prefix = "ss" + Math.round(Math.random() * 100000)
        htmlParsed = html.replace(matchTag, (tag, slash, name, attrs) ->
          obj = {}
          unless slash
            elems = elems.add("<" + name + "/>")
            if attrs
              $.each $("<div" + attrs + "/>")[0].attributes, (i, attr) ->
                obj[attr.name] = attr.value
                return

            elems.eq(-1).attr obj
          "<" + slash + "div" + ((if slash then "" else " id=\"" + prefix + (elems.length - 1) + "\"")) + ">"
        )
    
        # If no placeholder elements were necessary, just return normal
        # jQuery-parsed HTML.
        return $(html)  unless elems.length
    
        # Create parent node if it hasn't been created yet.
        parent = $("<div/>")  unless parent
    
        # Create the parent node and append the parsed, place-held HTML.
        parent.html htmlParsed
    
        # Replace each placeholder element with its intended element.
        $.each elems, (i) ->
          elem = parent.find("#" + prefix + i).before(elems[i])
          elems.eq(i).html elem.contents()
          elem.remove()
          return
        parent.children().unwrap()
    
      isExternal: (url) ->
        match = url.match(/^([^:\/?#]+:)?(?:\/\/([^\/?#]*))?([^?#]+)?(\?[^#]*)?(#.*)?/)
        return true  if typeof match[1] is "string" and match[1].length > 0 and match[1].toLowerCase() isnt location.protocol
        return true  if typeof match[2] is "string" and match[2].length > 0 and match[2].replace(
          new RegExp(":(#{ {http: 80, https: 443}[location.protocol]})?$"), "") isnt location.host
        false
    
      isHash: (url) ->
        hasPathname = (if (url.indexOf(window.location.pathname) > 0) then true else false)
        hasHash = (if (url.indexOf("#") > 0) then true else false)
        (if (hasPathname and hasHash) then true else false)
    
    
      shouldLoad: (url, blacklist) ->
        # URL will only be loaded if it's not an external link, or hash
        not @isExternal(url) and not @isHash(url)
    
      storePage: (object, url, html) ->
        $htmlDoc = @htmlDoc(html)
        object[url] = # Content is indexed by the url
          status: "loaded"
          title: $htmlDoc.find("title").text() # Stores the title of the page
          html: $htmlDoc # Stores the contents of the page
        object

      getContentById: (id, $html) ->
        # Grabs the new container's contents from the cache
        updatedContainer = $(id, $html).html()
        newContent = (if (updatedContainer.length) then $(updatedContainer) else null)
        newContent
    
      clearIfOverCapacity: (obj, cap) ->
        # Polyfill Object.keys if it doesn't exist
        unless Object.keys
          Object.keys = (obj) ->
            keys = []
            k = undefined
            for k of obj
              keys.push k  if Object::hasOwnProperty.call(obj, k)
            keys
        obj = {}  if Object.keys(obj).length > cap
        obj
        ### Keep home
        main = obj[mainPath]
        obj = {}
        obj[mainPath] = main
        ###

      pathToUrl: (path)->
        $("<a href=#{path}>").prop('href')
    
      


###
TODO:
Multi-page
- load new pages into new divs & animate
- initalize new page's javascript after insertion (maybe some init interface)

###