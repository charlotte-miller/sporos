CStone.Community.Search.Components.UI = React.createClass({
  mixins: [Backbone.React.Component.mixin],
  render: function() {
    var Results;
    var session = this.getModel()
    Results = React.createElement(CStone.Community.Search.Components.Results, {
      model: {
        session: this.getModel()
      },
      collection: {
        sources: session.get('sources'),
        results: session.get('results'),
      }
    });

    return <div id="search-ui-component">
        <div class="container">
          <div id="main-header-content">
            <a href="#" id="logo" name="logo">
              <img class="logo-img" src="/assets/white_cornerstone.png" alt="White cornerstone" />
            </a>
            <div class="search" id="global-search">
              <form class="search-form" role="search">
                <div class="input-group">
                  <input autocomplete="off" class="text" id="global-search-input" placeholder="What are you looking for?" type="text"> <input class="search-hint">
                  <div class="input-group-btn"></div>
                </div>
                <div class="examples">
                  Examples:&nbsp; <span class="thin">Kids, &nbsp;Parking, &nbsp;Small Groups, &nbsp;Luke 12:12, &nbsp;Current Series, &nbsp;Get Involved</span>
                </div>
              </form>
            </div>
          </div>
        </div>

      { Results }
    </div>;
  }
});
