CStone.Community.Pages.init()

$ ->
  if $('#go_home.full').length
    setTimeout (-> $('#go_home.full').removeClass('full')), 2000