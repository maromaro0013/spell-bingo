# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

m_room_id = ""
m_game_info = ""

click_spell = ->
  sheet_id = $(this).attr("sheet_id")
  elm = $(this)

  $.ajax({
    url: '/game/' + m_room_id + '/toggle_sheet',
    type: 'post',
    data: {sheet_id: sheet_id},
    dataType: 'json'
    success: (data)->
      elm.toggleClass("pushed_spell")
  })

append_spell_element = (tr, spell) ->
  class_name = "spell_cell"
  if (spell["pushed"] == true)
    class_name += " pushed_spell"

  sheet_id = spell["sheet_id"]
  td = $("<td>", {
    text: spell["name"],
    sheet_id: sheet_id,
    class: class_name
  })
  tr.append(td)

update_spell_table = ->
  $("#game-spells tr").remove()

  spells = m_game_info["spells"]

  count = 0
  for spell in spells
    if (count % m_game_info["spell_row_max"] == 0)
      tr = $("<tr>", {})
      append_spell_element(tr, spell)
    else if (count == m_game_info["spell_center"])
      td = $("<td>", {
        text: ""
        class: "pushed_spell"
      })
      tr.append(td)
      append_spell_element(tr, spell)
      count += 1
    else
      append_spell_element(tr, spell)

    count += 1
    if (count % m_game_info["spell_row_max"] == 0)
      $("#game-spells").append(tr)

  $(".spell_cell").click(click_spell)

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

  $("#back_button").click( ->
    location.href = '/room/index'
  )
)
