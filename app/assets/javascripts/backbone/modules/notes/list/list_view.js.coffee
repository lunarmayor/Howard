Howard.module 'Notes.List', (List, App) ->
  class List.ListItem extends App.Views.ItemView
    template: 'notes/list/templates/_note'
    tagName: 'li'
    attributes:
      'draggable': true

    events:
      'dragstart': 'tempHide'
      'dragend': 'tempShow'
      'dragover': 'dragging'


    tempHide: (e) ->
      $(e.target).animate({opacity: 0.6}, 300)
      dragIcon = document.createElement('img')
      dragIcon.src = 'assets/drag.png'
      $(dragIcon).addClass('drag-icon')
      e.originalEvent.dataTransfer.setDragImage(dragIcon, 0, 0)

      e.originalEvent.dataTransfer.setData('Text', @model.get('id'))

    
    dragging: (e) ->
      e.preventDefault()

    tempShow: (e) ->
      $(e.target).animate({opacity: 1}, 300)


    onRender: ->
      @el.style.opacity = 0
      @$el.animate(opacity: 1, 500)



  class List.View extends App.Views.CompositeView
    template: 'notes/list/templates/list'
    childView: List.ListItem
    className: 'note-list'
    childViewContainer: 'ul'

    events:
      'click .fa-plus': 'addInput'
      'input blur': 'createNote'
      'input keyup': 'checkIfEnter'


    createNote: ->
      note = App.request('new:note:entity')
      note.set('content', @$el.find('input').val())
      @collection.add(note)
      note.save({}, {silent: true})


    addInput: ->
      @$el.find('ul').append("<li class='new'><input type='text'/></li>").find('input').focus()
      

    cancelEvent: (e) ->
      $('.fa-trash').animate({color: 'red'}, 400)
      $(this).addClass('over')

      e.preventDefault()

    unhighlight: ->
      $(this).removeClass('over')


    handleDrop: (e) =>
      e.originalEvent.stopPropagation()
      e.originalEvent.preventDefault()
      id = e.originalEvent.dataTransfer.getData('Text')
      @collection.findWhere(id: id * 1).destroy()
      @$el.find('.fa-trash-container').removeClass('over')
   

    onShow: ->
      dragIcon = document.createElement('img')
      dragIcon.src = 'assets/drag.png'

      socket = io.connect('//localhost:3001/')
      socket.on('message', (data) =>
        @collection.add(JSON.parse(data))
      )

      @$el.find('.fa-trash-container').on('dragover', @cancelEvent)
      @$el.find('.fa-trash-container').on('dragleave', @unhighlight)
      @$el.find('.fa-trash-container').on('drop', @handleDrop)
