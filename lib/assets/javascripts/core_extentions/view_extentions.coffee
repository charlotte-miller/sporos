class CStone.Shared.Backbone.ExtendedView extends Backbone.View

  # Merges all options into the View instead of just the 'special' options below
  # ['model', 'collection', 'el', 'id', 'attributes', 'className', 'tagName', 'events']
  constructor: (options={})->
    _(@).extend(options)
    super