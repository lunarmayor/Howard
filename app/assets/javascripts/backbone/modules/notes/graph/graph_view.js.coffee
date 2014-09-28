Howard.module 'List.Graph', (Graph)->
  ###
  # Displays a chart
  #
  # @class Chart
  ###
  class Graph.BubbleView extends Marionette.ItemView

    template: 'notes/graph/templates/chart'
    className: 'chart'
    nodes: []


    onShow: =>
      @loadChart()


    # Setup foundational D3 chart structure
    # Nothing here is based on user data
    loadChart: =>
      # Set margin, width and height of SVG
      @margin = {top: 30, right: 60, bottom: 57, left: 90}
      @w = @$el.width() - 30 - @margin.left - @margin.right
      @h = $(window).height() - @margin.top - @margin.bottom - 100
      @center = {x: @w / 2, y: @h / 2}
      @layout_gravity = -0.01
      @damper = 0.5

      console.log @margin, @w, @h, @center


      # Create d3 SVG and insert into page
      @svg = d3.select('#chart').append("svg")
      .attr("width", @w + @margin.left + @margin.right)
      .attr("height", @h + @margin.top + @margin.bottom)
      .append("g")
      .attr("transform", "translate(" + @margin.left + "," + @margin.top + ")")

      @createNodes()
      @start()
      @loadData()



    createNodes: ->
      @nodes = []
      @collection.each (node) =>
        node = {
          id: node.get('id')
          content: node.get('content')
          x: Math.random() * @w
          y: Math.random() * @h
          fill: "rgb(#{Math.floor(Math.random() * 255)}, 40, 40)"
          radius: 60
        }

        @nodes.push node

    charge: (d) ->
      -Math.pow(d.radius, 2.0) / 1

    # Create node objects from Backbone collection
    loadData: ->
      @notes = @svg.selectAll('g').data @nodes, (d) -> d.id

      @notes.enter().append('circle')
        .attr('fill', (d) -> d.fill)
        .attr('r', 0)
        .call(@force.drag)
        .transition().duration(2000).attr("r", (d) -> d.radius)




    start: () =>
      @force = d3.layout.force()
        .nodes(@nodes)
        .size([@w, @h])

      @force.gravity(@layout_gravity)
        .charge(@charge)
        .friction(0.9)
        .on 'tick', (e) =>
          @notes.each(@moveTowardsCenter(e.alpha))
            .attr("cx", (d) -> d.x)
            .attr("cy", (d) -> d.y)
      @force.drag()
      @force.start()

    moveTowardsCenter: (alpha) =>
      (d) =>
        d.x = d.x + (@center.x - d.x) * (@damper + 0.02) * alpha
        d.y = d.y + (@center.y - d.y) * (@damper + 0.02) * alpha






