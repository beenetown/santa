$('html').click (e) ->
  if $('#nav').is(":visible") && !$('#signin').is(":visible")
    $('#nav').hide()


$(document).on "ready page:load", (e) ->
  $('#show-signin').click ->
    $('#signin').show()
    # event.stopPropagation()
  
  $('#show-nav').click ->
    $('#nav').toggle()
    event.stopPropagation()

  $('#close').click ->
    $(this).parent().hide()
