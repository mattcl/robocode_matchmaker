# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->

  if $('#upload_form_modal').find('.alert-box').length > 0
    $('#upload_form_modal').foundation('reveal', 'open')

  $('#show_upload_link').on 'click', ->
    $('#upload_form_modal').foundation('reveal', 'open')
    return false

  $('#upload_cancel_button').on 'click', ->
    $('#upload_form_modal').foundation('reveal', 'close')
    return false

  if $('#averages_graph').length > 0
    refined_averages = for key, value of $('#averages_graph').data('averages')
      { label: key, value: value }
    Morris.Bar
      element: 'averages_graph'
      data: refined_averages
      xkey: 'label'
      ykeys: ['value']
      labels: ['Points']
      hideHover: 'auto'
      xLabelAngle: 30

