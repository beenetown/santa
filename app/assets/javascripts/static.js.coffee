$('html').click ->
  if $('#nav').is(":visible") #&& !$('#signin').is(":visible")
    $('#nav').hide()

$(document).on "ready page:load", ->
  $("#signin").click (e) ->
    e.stopPropagation()

  # This breaks signout link
  # $("#nav").click (e) ->
  #   e.stopPropagation()

  $(document).keyup (e) ->
    if e.keyCode == 27 && $('#nav').is(":visible")
      $('#nav').hide()  

  $('#show-signin').click (e) ->
    $('#signin').toggle()
    e.stopPropagation()
  
  $('#show-nav').click (e) ->
    $('#nav').toggle()
    e.stopPropagation()

  $('.close').click ->
    $(this).parent().hide()

  $('.minimize').click ->
    $(this).parent().parent().children().hide()
    $(this).hide()
    $('.maximize').show()
    $('.sidebar > h1').show()
    $('.sidebar').addClass('minimized')

  $('.maximize').click ->
    $(this).parent().parent().children().show()
    $('.sidebar').removeClass('minimized')
    $(this).hide()
    $('.minimize').show()

