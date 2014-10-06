Howard.module 'Lists.List', (List, App) ->
  class List.IndexItem extends App.Views.ItemView
    template: 'lists/list/templates/_index_list_item'
    tagName: 'li'

    attributes:
      'draggable': true

    events:
      'dragstart': 'dragStart'
      'dragend': 'dragEnd'
      'dragover': 'dragging'
      'click': -> App.execute('show:list', @model.get('id'))
      'destroy': 'destroyModel'

    onRender: ->
      if @model.get('id')
        @el.style.opacity = 0
        @$el.animate(opacity: 1, 700)

    dragStart: (e) ->
      $(e.target).animate({opacity: 0.6}, 300)
      dragIcon = document.createElement('img')
      dragIcon.src = 'assets/drag.png'
      $(dragIcon).addClass('drag-icon')
      e.originalEvent.dataTransfer.setDragImage(dragIcon, 0, 0)

      e.originalEvent.dataTransfer.setData('Text', @model.get('id'))

    dragging: (e) ->
      e.preventDefault()

    dragEnd: (e) ->
      $(e.target).animate({opacity: 1}, 300)

    destroyModel: ->
      @model.destroy()

  class List.IndexView extends App.Views.CompositeView
    template: 'lists/list/templates/index_list'
    childView: List.IndexItem
    className: 'note-list list'
    childViewContainer: 'ul'
    
    events:
      'click .fa-plus': 'addInput'
      'blur input': 'createList'
      'keyup input': 'handleKeyUp'
      'keydown input': 'handleKeyDown'
      'click li': 'select'

    behaviors:
      KeyCommands:
        187: -> @addInput()
        38: -> @selectPrevious()
        40: -> @selectNext()
        84: -> @deleteSelected()
        8: -> @deleteSelected()

    deleteSelected: ->
      selected = @$el.find('li.selected')

      if selected.length
        selected.trigger('destroy')

    select: (e) ->
      @$el.find('li').removeClass('selected')
      $(e.currentTarget).addClass('selected')

    selectPrevious: ->
      selected = @$el.find('li.selected')
      
      if selected.length
        previousLi = selected.prev('li')
        if previousLi.length
          selected.removeClass('selected')
          previousLi.addClass('selected')
        else
          selected.removeClass('selected')
          li = @$el.find('li')
          li.last().addClass('selected') if li.length
      else
        li = @$el.find('li')
        li.last().addClass('selected') if li.length

    selectNext: =>
      selected = @$el.find('li.selected')
      
      if selected.length
        nextLi = selected.next('li')
        if nextLi.length
          selected.removeClass('selected')
          nextLi.addClass('selected')
        else
          selected.removeClass('selected')
          li = @$el.find('li')
          li.first().addClass('selected') if li.length
      else
        li = @$el.find('li')
        li.first().addClass('selected') if li.length

    handleKeyUp: (e) ->
      if e.keyCode == 13
        @createList()
    
    handleKeyDown: (e) ->
      if e.keyCode == 8 and @$el.find('input').val() == ""
        @destroyInput()

    createList: ->
      value = @$el.find('input').val()

      if value != ''
        list = App.request('new:list:entity')
        list.set('name', value)
        @$el.find('li.new').remove()
        @collection.add(list)
        list.save({}, {silent: true})
        @$el.find('.fa-plus').show()

    destroyInput: ->
      @$el.find('li.new').animate({opacity: 0}, 400, =>
        @$el.find('li.new').remove()
        @$el.find('.fa-plus').show()
      )

    addInput: ->
      unless @$el.find('input').length
        @$el.find('.fa-plus').hide()
        ul = @$el.find('ul').append("<li class='new'><input type='text'/></li>")
        li = ul.find('li')
        li.animate({opacity: 1}, 500)
        input = li.find('input').focus()

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

      @$el.find('.fa-trash-container').on('dragover', @cancelEvent)
      @$el.find('.fa-trash-container').on('dragleave', @unhighlight)
      @$el.find('.fa-trash-container').on('drop', @handleDrop)

