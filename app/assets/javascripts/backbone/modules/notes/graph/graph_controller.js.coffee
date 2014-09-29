Howard.module 'List.Graph', (Graph, App) ->

  Graph.Controller =
    setupDefaultList: ->
      graph = new Graph.View({collection: @getNotes()})

      App.mainRegion.show(graph)


    getNotes: ->

      new Backbone.Collection(
        [{id: 1, content: 'hello'},
          {id: 2, content: 'goodbye'},
          {id: 3, content: 'goodbye'},
          {id: 4, content: 'goodbye'},
          {id: 5, content: 'goodbye'},
          {id: 6, content: 'goodbye'},
          {id: 7, content: 'goodbye'},
          {id: 8, content: 'hello'},
          {id: 9, content: 'goodbye'},
          {id: 10, content: 'goodbye'},
          {id: 11, content: 'goodbye'},
          {id: 12, content: 'goodbye'},
          {id: 13, content: 'goodbye'},
          {id: 14, content: 'goodbye'}]
      )

