Howard.module 'Notes.List', (List, App) ->

  List.Controller =
    showDefaultNotes: ->
      list = new List.View({collection: @getNotes()})
      App.mainRegion.show(list)

      App.reqres.setHandler('note:collection', -> list.collection)

    getNotes: ->
      App.request('note:entities')
