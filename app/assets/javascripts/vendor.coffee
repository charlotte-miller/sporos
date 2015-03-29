# NOTE: Bump the version after ANY changes
#
#  -- Base -----
#= require vendor_preload_config
#= require underscore
#= require jquery
#= require jquery.animate-enhanced
#= require browser_compatibility/localstorage-polyfill
#= require es6-promise
#= require fastclick
#= require typeahead.js/dist/bloodhound.js
#= require handlebars/handlebars.runtime.js
#= require backbone
#= require backbone-filtered-collection
#  require backbone_query/backbone-query
#= require backbone-relational
#= require Backbone.BindTo
#= require Backbone.Handlebars
#= require pace
#  require moment
#  require utility/boba-0.0.2
#
#  -- Community Only -----
#= require headroom.js/dist/headroom.js
#= require headroom.js/dist/jQuery.headroom.js
#= require isotope/dist/isotope.pkgd
#= require vide
#= require jquery-resize/jquery.ba-resize.js
#
#  -- Library Only -----
# vimeo

$ ->
  FastClick.attach(document.body)