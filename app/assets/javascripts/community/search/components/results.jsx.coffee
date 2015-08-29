CStone.Community.Search.Components.Results = React.createClass
  mixins: [Backbone.React.Component.mixin]

  render: ->
    `<div class="search-suggestions-dropdown">
       <div class="search-results">
         { buildSources() }
         { buildResults() }
       </div>
     </div>`


  buildResults: =>
    buildEmptyHelp =
      `<div class="search-help" id="empty-help">
        <div class="search-help-content">
          <h3 class="search-help-text">
            <i class="icon"></i>
            Sorry, Nothing like that was found.
            <p class="lead">Our search is getting smarter every day, but we still don't understand "{this.props.current_search}".  Try searching someting similar.</p>
          </h3>
        </div>
      </div>`

    buildInitHelp =
      `<div class="search-help" id="init-help">
         <div class="search-help-content">
           <h3 class="search-help-text">
             <i class="icon"></i>
             Try Searching:
             <a class="text-spinner" href="#">"When does Church start", "Parking", "Child care", "BART &amp; MUNI", "Haiti Mission", "Videos", "Music", "1 Peter 2", "Ministries"</a>
             <p class="lead">We want you to find what you are looking for, so start typing to learn more about our community &amp; media library.</p>
           </h3>
         </div>
       </div>`

    eachResult = =>
      @state.results.map ->
        `<li class="{this.focusClass} suggestion" data-result_id={this.id} >
           <i class="{this.source} icon"></i>
           { this.payload }
         </li>
        `

    each

    buildResults =
      `<ol class="suggestion-list">
         { eachResult() }
       </ol>`

    return buildInitHelp  if @state.init_help
    return buildEmptyHelp if @state.empty_help
    return buildResults



  buildSources: =>
    eachSource = =>
      @state.session.get('sources').map -> #.select(this.showMe)
        caret = `<span class="caret"></span>`
        count = `<span class="count">{this.count}</span>`

        `<li class={this.focusClass+" suggestion-nav-source"}>
           <a data-source={this.name} href={"#search/filter/"+this.name}>
             <i class={this.name+' icon'}></i>
             { this.title }
             { this.isAll && caret }
             { this.count && count }
           </a>
         </li>`

    `<ul class="suggestion-nav-sources">
      { eachSource() }
     </ul>`
