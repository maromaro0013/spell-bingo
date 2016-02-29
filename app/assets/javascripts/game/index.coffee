# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

m_room_id = ""
m_game_info = ""

update_game_info = ->
  $.ajax({
    url: '/game/' + m_room_id + '/info',
    type: 'post',
    data: {},
    dataType: 'json'
    success: (data)->
      m_game_info = data
      console.log data
  })

$(document).on('ready page:load', ->
  ary = window.location.href.split('/')
  m_room_id = ary[ary.length - 2]

  update_game_info()
)
