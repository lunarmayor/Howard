Howard.module 'Notes.List', (List, App) ->

  List.Controller =
    showDefaultNotes: ->
      list = new List.View({collection: @getNotes()})
      App.mainRegion.show(list)

      lists = new App.Lists.List.View({collection: @getLists()})
      App.sidePaneRegion.show(lists) unless App.sidePaneRegion.currentView

      App.reqres.setHandler('note:collection', -> list.collection)

    getNotes: ->
      App.request('note:entities')

    getLists: ->
      App.request('list:entities')
