# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  # display graphs on the show view
  if $('#breakdown_chart').length > 0
    Morris.Bar
      element: 'breakdown_chart'
      data: $('#breakdown_chart').data('entries')
      xkey: 'proper_name'
      ykeys:  ['ram_damage', 'ram_bonus', 'survival', 'survival_bonus', 'bullet_damage', 'bullet_bonus']
      labels: ['Ram Damage', 'Ram Bonus', 'Survival', 'Survival Bonus', 'Bullet Damage', 'Bullet Bonus']
      #barColors: ['#E2003C', '#F25500', '#00ECE1', '#E4FF0A', '#63DB28', '#FF4C88']
      barColors: ['#FFED3E', '#8FBD08', '#853585', '#CE5811', '#2CA0C9', '#217E94']
      stacked: true
      hideHover: 'auto'
      xLabelAngle: 30

    Morris.Donut
      element: 'bullet_damage_chart'
      data: $('#bullet_damage_chart').data('values')

    Morris.Donut
      element: 'ram_damage_chart'
      data: $('#ram_damage_chart').data('values')

    Morris.Donut
      element: 'survival_chart'
      data: $('#survival_chart').data('values')
