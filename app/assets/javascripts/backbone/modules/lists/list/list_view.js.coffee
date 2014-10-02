Howard.module 'Lists.List', (List, App) ->
  class List.Item extends App.Views.ItemView
    template: 'lists/list/templates/_list'
    tagName: 'li'
    events:
      'dragover': 'highlight'
      'dragleave': 'unhighlight'
      'drop': 'handleDrop'

    highlight: (e) ->
      e.preventDefault()
      @$el.addClass('over')

    unhighlight: (e) ->
      @$el.removeClass('over')

    handleDrop: (e) ->
      e.originalEvent.stopPropagation()
      e.originalEvent.preventDefault()
      id = e.originalEvent.dataTransfer.getData('Text')
      notes = App.request('note:entities')
      note = notes.findWhere(id: id * 1).set('list_id', @model.get('id'))
      note.save(null, {silent: true, success: ->
        notes.remove(note)
      })
      @$el.removeClass('over')


  class List.View extends App.Views.CompositeView
    template: 'lists/list/templates/list'
    childView: List.Item
    className: 'drop-list'
    childViewContainer: 'ul'

      
