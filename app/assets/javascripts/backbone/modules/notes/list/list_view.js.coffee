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
      e.originalEvent.dataTransfer.setDragImage(dragIcon, 10, 10)

    tempShow: (e) ->
      $(e.target).animate({opacity: 1}, 300)

    dragging: (e) ->

    onRender: ->
      @el.style.opacity = 0
      @$el.animate(opacity: 1, 500)



  class List.View extends App.Views.CompositeView
    template: 'notes/list/templates/list'
    childView: List.ListItem
    className: 'note-list'
    childViewContainer: 'ul'

    onShow: ->
      dragIcon = document.createElement('img')
      dragIcon.src = 'assets/drag.png'

      socket = io.connect('//localhost:3001/')
      socket.on('message', (data) =>
        text =  JSON.parse(data).text
        @collection.add({content: text})
      )
