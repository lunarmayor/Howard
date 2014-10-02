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

    App.reqres.setHandler "note:entities", API.getDefaultNotes

