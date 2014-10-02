Howard.module "Entities", (Entities, App) ->

	class Entities.Note extends Entities.Model
      urlRoot: 'notes'

	class Entities.NoteCollection extends Entities.Collection
	  url: 'notes'
	  model: Entities.Note

	API = 
      getDefaultNotes: ->
      	@notes ||=  do ->
          new Entities.NoteCollection()
      	  notes.fetch()
      	  notes

      getNewNote: ->
        new Entities.Note()

    App.reqres.setHandler "note:entities", API.getDefaultNotes
    App.reqres.setHandler "new:note:entity", API.getNewNote

