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
#= require react
#= require vendor_modified/react_ujs
#= require backbone
#= require backbone-filtered-collection
#= require backbone-relational
#= require backbone-react-component
#= require pace
#= require moment
#  require utility/boba-0.0.2
#= require autosize
#= require bootstrap/alert
#
#  -- Community Only -----
#= require isotope/dist/isotope.pkgd
#= require vide
#= require jquery-resize/jquery.ba-resize.js
#= require theaterjs/dist/theater.min.js
#
#  -- Library Only -----
# vimeo

$ ->
  FastClick.attach(document.body)
