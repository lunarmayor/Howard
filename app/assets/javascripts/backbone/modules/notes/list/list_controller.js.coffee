Howard.module 'Notes.List', (List, App) ->

  List.Controller =
    showDefaultNotes: ->
      list = new List.View({collection: @getNotes()})
      App.mainRegion.show(list)


    getNotes: ->

      new Backbone.Collection(
        [{id: 1, content: 'read a book'},
          {id: 2, content: 'buy a tripod'},
          {id: 3, content: 'I really need to start being more appreciative of the people around me'},
          {id: 4, content: 'I\'m trying to eat healthier'},
          {id: 5, content: 'actually feeling really sad today '},
          {id: 6, content: 'remember to check the ebay listing '},
          {id: 7, content: 'opens the door to my conciousness and then rips it open'},
          {id: 8, content: 'sing louder and prouder'},]
      )

