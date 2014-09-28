M76.module 'List.Graph', (Graph)->
  ###
  # Displays a chart
  #
  # @class Chart
  ###
  class Graph.View extends Marionette.ItemView

    template: ''
    className: 'chart'


    onShow: =>
      @loadChart()


    # Setup foundational D3 chart structure
    # Nothing here is based on user data
    loadChart: =>
      # Set margin, width and height of SVG
      @margin = {top: 30, right: 60, bottom: 57, left: 90}
      @w = @$el.width() - 30 - @margin.left - @margin.right
      @h = 300 - @margin.top - @margin.bottom
      @center = {x: @width / 2, y: @height / 2}
      @layout_gravity = -0.01
      @damper = 0.1

      # Create d3 SVG and insert into page
      @svg = d3.select('#chart').append("svg")
      .attr("width", @w + @margin.left + @margin.right)
      .attr("height", @h + @margin.top + @margin.bottom)
      .append("g")
      .attr("transform", "translate(" + @margin.left + "," + @margin.top + ")")



    # Create node objects from Backbone collection
    loadData: (collection) =>
      