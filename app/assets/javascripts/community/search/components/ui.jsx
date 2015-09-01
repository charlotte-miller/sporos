//= require ./results

if (!CStone.Community.Search) { CStone.Community.Search = {Components:{}}; }
CStone.Community.Search.Components.UI = React.createClass({
  mixins: [Backbone.React.Component.mixin],

  session: function(){ return this.getModel(); },

  render: function() {
    var defaults = {
      dropdown_visible:false
    };

    var session, session_model, Results;
    session = this.state.model || defaults;
    session_model = this.session();
    if (session.dropdown_visible) {
      Results = React.createElement(CStone.Community.Search.Components.Results, {
        model: {
          session: session_model
        },
        collection: {
          sources: session_model.get('sources'),
          results: session_model.get('results'),
        }
      });
    }

    return (
      <div id="main-header" className={"header"+(session.dropdown_visible ? ' search-focused' : '')}>
        <div className="container">
          <div id="main-header-content">
            <a href="#" id="logo" name="logo">
              <img className="logo-img" src="/assets/white_cornerstone.png" alt="White cornerstone"/>
            </a>
            <div className="search" id="global-search">
              <form className="search-form" role="search" onSubmit={this.onSubmit}>
                <div className="input-group" >
                  <input  autoComplete="off" placeholder="What are you looking for?" type="text"
                          ref="global-search-input" className="text" id="global-search-input"
                          value={session.current_search}
                          onFocus={this.onInputFocus}
                          onChange={  this.onInputKey}
                          onKeyDown={ this.onInputKey }
                          />

                  <input className="search-hint" value={ session.hint_visible ? session.current_hint : ''} />
                  <div className="input-group-btn">
                    <button className="search-button submit" type="submit" onClick={this.onIconClick}>
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
        </div>
      </div>
    );
  },

  // = Event Handlers =
  // ----------------------------------------------------------------------
  onInputFocus: function(e) {
    if (e) { e.preventDefault();}
    this.session().set({
      active_ui: this.ui_name,
      dropdown_visible: true,
    });
  },

  onIconClick: (function(e) {
    e.preventDefault();
    this.session().set({ active_ui: this.ui_name });
    this.session().toggle('dropdown_visible');
    if (this.session().get('dropdown_visible')) {
      this.session().set({ current_search: this.$('.text').val()});
      this.$('.text').focus();
    } else {
      this.$('.submit, .text').blur();
    }
  }),

  onSubmit: function(e) {
    e.preventDefault();
    this.session.acceptHint();
    this.session.openFocused();
  },

  onInputKey: function(e) {
    var _this, target, $target, key_code, specialKeyCodeMap;
    _this = this;
    target = e.target;
    $target = $(target);
    key_code = e.which || e.keyCode;
    specialKeyCodeMap = {
      9: 'tab',
      27: 'esc',
      39: 'right',
      13: 'enter',
      38: 'up',
      40: 'down'
    };
    if (e.type === 'keydown' && specialKeyCodeMap[key_code]) {
      switch (specialKeyCodeMap[e.which]) {
        case 'up':
          e.preventDefault();
          _this.session().moveFocus('up');
          break;
        case 'down':
          e.preventDefault();
          _this.session().moveFocus('down');
          break;
        case 'right':
          if ($target.isCursorAtEnd()) {
            e.preventDefault();
            _this.session().acceptHint();
          }
          break;
        case 'tab':
          e.preventDefault();
          if ($target.isCursorAtEnd()) {
            _this.session().acceptHint();
          }
          break;
        case 'enter':
          e.preventDefault();
          _this.session().acceptHint();
          _this.session().openFocused();
          break;
        case 'esc':
          e.preventDefault();
          _this.session().set({
            dropdown_visible: false
          });
      }
    }
    if (e.type === 'input'  && !specialKeyCodeMap[key_code]) {
      var backspace_keys;
      backspace_keys = [8, 91, 93];
      if (_(backspace_keys).include(key_code) || e.type === 'cut') {
        if (!(target.value.length && $target.isCursorAtEnd())) {
          _this.session().set({
            hint_visible: false
          });
        }
      }
      return _this.session().set({
        current_search: target.value
      });
    }
  },


  // React to Models - Change DOM
  // ----------------------------------------------------------------------

  // @listenTo @session, 'change:dropdown_visible',  @thenScrollToMainUI


  thenScrollToMainUI: (function(_this) {
    return function() {
      var col_sm_min, container, scroll_to;
      if (!(_this.ui_name === 'main' && _this.session.get('dropdown_visible'))) {
        return;
      }
      col_sm_min = 768;
      container = $('#main-page');
      scroll_to = container.width() < col_sm_min ? '#global-search' : '#main-header';
      return $(scroll_to).smoothScroll(CStone.Animation.layoutTransition.duration, CStone.Animation.layoutTransition.easing, {
        container: container,
        offset: -100
      });
    };
  })(this),

});
