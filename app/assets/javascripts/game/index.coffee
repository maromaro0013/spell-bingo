# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

m_room_id = ""
m_game_info = ""

update_spell_table = ->
  $("#game-spells tr").remove()

  spells = m_game_info["spells"]

  count = 0
  for spell in spells
    if (count % m_game_info["spell_row_max"] == 0)
      tr = $("<tr>", {})
      td = $("<td>", {
        text: spell["name"]
      })
      tr.append(td)
    else if (count == m_game_info["spell_center"])
      td = $("<td>", {
        text: ""
      })
      tr.append(td)
      td = $("<td>", {
        text: spell["name"]
      })
      tr.append(td)
      count += 1
    else
      td = $("<td>", {
        text: spell["name"]
      })
      tr.append(td)

    count += 1
    if (count % m_game_info["spell_row_max"] == 0)
      $("#game-spells").append(tr)

update_game_info = ->
  $.ajax({
    url: '/game/' + m_room_id + '/info',
    type: 'post',
    data: {},
    dataType: 'json'
    success: (data)->
      m_game_info = data
      update_spell_table()
  })

$(document).on('ready page:load', ->
  ary = window.location.href.split('/')
  m_room_id = ary[ary.length - 2]

  update_game_info()
)
