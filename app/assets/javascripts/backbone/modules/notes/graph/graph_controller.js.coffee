Howard.module 'List.Graph', (Graph, App) ->

  Graph.Controller =
    setupDefaultList: ->
      graph = new Graph.View({collection: @getNotes()})

      App.mainRegion.show(graph)


    getLNotes: ->
      App.request "default:list"