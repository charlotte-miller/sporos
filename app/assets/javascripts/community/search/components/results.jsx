CStone.Community.Search.Components.Results = React.createClass({
  mixins: [Backbone.React.Component.mixin],


  render: function(){
    var _this = this;
    var session = _this.getModel().session;

    var buildSources= function() {
      var eachSource = function() {
        var results_collection  = _this.getCollection().results;
        var sources_collection  = _this.getCollection().sources;
        var grouped_results = results_collection.allGrouped();
        var source_nav_data = results_collection.map(function(source) {
          var count;
          var results = grouped_results[source.get('name')] || [];
          return {
            name: source.get('name'),
            title: source.get('title'),
            count: count = (results !== null ? results.length : 0),
            showMe: !!(count || !_this.results_collection.length),
            focusClass: source.get('focus') ? 'active' : ''
          };
        });
        source_nav_data.unshift({
          name: 'all',
          title: 'All',
          count: results_collection.length,
          isAll: true,
          showMe: _(grouped_results).size() !== 1,
          focusClass: sources_collection.findWhere({
            focus: true
          }) ? '' : 'active'
        });

        return source_nav_data.map(function(source) {
          var caret, count;
          caret = <span class="caret"></span>;
          count = <span class="count">{source.count}</span>;
          return (
            <li class={source.focusClass+" suggestion-nav-source"}>
              <a data-source={source.name} href={"#search/filter/"+source.name}>
                <i class={this.name+' icon'}></i>
                { source.title }
                { source.isAll && caret }
                { source.count && count }
              </a>
            </li>
          );
        });
      };
      return(
        // <div class="suggestions">
          <ul class="suggestion-nav-sources">
            { eachSource() }
          </ul>
        // </div>
      );
    };

    var buildResults= function() {
      var buildEmptyHelp, buildInitHelp, buildResults, eachResult;
      buildEmptyHelp = <div class="search-help" id="empty-help">
        <div class="search-help-content">
          <h3 class="search-help-text">
            <i class="icon"></i>
            Sorry, Nothing like that was found.
            <p class="lead">Our search is getting smarter every day, but we still do not understand "{session.get('current_search')}".  Try searching someting similar.</p>
          </h3>
        </div>
      </div>;

      buildInitHelp = <div class="search-help" id="init-help">
         <div class="search-help-content">
           <h3 class="search-help-text">
             <i class="icon"></i>
             Try Searching:
             <a class="text-spinner" href="#">"When does Church start", "Parking", "Child care", "BART &amp; MUNI", "Haiti Mission", "Videos", "Music", "1 Peter 2", "Ministries"</a>
             <p class="lead">We want you to find what you are looking for, so start typing to learn more about our community &amp; media library.</p>
           </h3>
         </div>
       </div>;

      eachResult = function() {
        return _this.state.results.map(function(result) {
          return <li class="{result.focusClass} suggestion" data-result_id={result.id} >
           <i class="{result.source} icon"></i>
           { result.payload }
         </li>
        ;
        });
      };

      buildResults = <ol class="suggestion-list">
         { eachResult() }
       </ol>;

      switch (session.searchState()) {
        case 'pre-search' : return buildInitHelp;
        case 'no-results' : return buildEmptyHelp;
        default: return buildResults;
      }
    };

    return <div class="search-suggestions-dropdown">
      <div class="search-results">
        { buildSources() }
        { buildResults() }
      </div>
    </div>;
  },
});
