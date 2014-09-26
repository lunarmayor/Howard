Howard.module 'List.Graph', (Graph, App) ->

  Graph.Controller =
    setupDefaultList: ->
      graph = new Graph.Visualization({collection: @getLinks()})

      App.mainRegion.show(graph)


    getLinks: ->
      App.request "default:list"