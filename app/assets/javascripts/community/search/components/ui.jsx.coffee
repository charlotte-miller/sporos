CStone.Community.Search.Components.UI = React.createClass
  mixins: [Backbone.React.Component.mixin]

  render: ->
    Results = React.createElement CStone.Community.Search.Components.Results, {
      model: { session:@state.model }
      collection: { results:@state.model.get('results') }}

    `
    <div id="search-ui-component">
      <h1>Hello World!</h1>
      <Results/>
    </div>
    `