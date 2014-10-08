Howard.module 'Lists.List', (List, App) ->
  class List.Item extends App.Views.ItemView
    template: 'lists/list/templates/_list'
    tagName: 'li'
    events:
      'dragover': 'highlight'
      'dragleave': 'unhighlight'
      'drop': 'handleDrop'
      'click': -> App.execute('show:list', @model.get('id'))

    serializeData: (model) ->
      _.extend(@model.attributes, {index: @options.index})

    highlight: (e) ->
      e.preventDefault()
      @$el.addClass('over')

    unhighlight: (e) ->
      @$el.removeClass('over')

    handleDrop: (e) ->
      e.originalEvent.stopPropagation()
      e.originalEvent.preventDefault()
      id = e.originalEvent.dataTransfer.getData('Text')
      notes = App.request('note:collection')
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

    onRender: ->
      #@$el.find('ul').prepend("<li class='new-list'>New List</i><div class='index'>0</div></li>")

    onShow: ->

      App.reqres.setHandler('list:id:at:index', (index) =>
        model = @collection.at((index * 1) - 1)
        
        if model
          model.get('id')
        else
          false
      )

      App.commands.setHandler('highlight:list', (listId) =>
        model = @collection.findWhere({id: listId * 1})
        el = @children.findByModel(model).$el
        el.one("transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", ->
          el.removeClass('flashing')
        )
        el.addClass('flashing')
      )
    childViewOptions: (model) ->
      {
        index: @collection.indexOf(model) + 1
      }

      
