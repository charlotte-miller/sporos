#= require_self
#= require shared
#= require community/news
#= require community/pages
#= require community/search

# Initialize Namespace
window.CStone =
  Community: {}  # News, Pages, Search
  Media:     {}
  Shared:    {}  # Backbone, Helpers, Utils
  Animation:
    layoutTransition:
      easing :  'easeInOutQuint'
      duration: 400