# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

drawChart = ->
  task_array = $('#tasks').data('url')
  project = $('#project').data('url')
  unused_budget = parseFloat(project.budget, 10)
  #google_array = new Array
  #google_array[0] = new Array(1)
  google_array = [['Task', 'Amount per Task']]
  #google_array[0][1] = ['Amount per Task']
  i = 0
  while i < task_array.length
    #google_array[i] = new Array(1)
    google_array.push [task_array[i].name, parseFloat(task_array[i].spent, 10)]
    #google_array[i][1] = [task_array[i].spent]
    unused_budget -= parseFloat(task_array[i].spent, 10)
    i++
  google_array.push ['Unused', unused_budget]
  data = google.visualization.arrayToDataTable(google_array)
  options = title: "Project Budget Pie Chart"
  chart = new google.visualization.PieChart(document.getElementById("chart_div"))
  chart.draw data, options
google.load "visualization", "1",
  packages: ["corechart"]

google.setOnLoadCallback drawChart