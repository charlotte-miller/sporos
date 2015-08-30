CStone.Community.Search.Components.UI = React.createClass({
  mixins: [Backbone.React.Component.mixin],
  render: function() {
    var Results;
    var session = this.getModel();
    Results = React.createElement(CStone.Community.Search.Components.Results, {
      model: {
        session: this.getModel()
      },
      collection: {
        sources: session.get('sources'),
        results: session.get('results'),
      }
    });

    return <div className="container">
      <div id="main-header-content">
        <a href="#" id="logo" name="logo">
          <img className="logo-img" src="/assets/white_cornerstone.png" alt="White cornerstone"/>
        </a>
        <div className="search" id="global-search">
          <form className="search-form" role="search">
            <div className="input-group">
              <input autoComplete="off" className="text" id="global-search-input" placeholder="What are you looking for?" type="text"/>
              <input className="search-hint" />
              <div className="input-group-btn">
                <button className="search-button submit" type="submit">
                  <i className="glyphicon glyphicon-search"></i>
                </button>
              </div>
            </div>
            <div className="examples">
              Examples:&nbsp; <span className="thin">Kids, &nbsp;Parking, &nbsp;Small Groups, &nbsp;Luke 12:12, &nbsp;Current Series, &nbsp;Get Involved</span>
            </div>
          </form>
          { Results }
        </div>
      </div>
    </div>;
  }
});
