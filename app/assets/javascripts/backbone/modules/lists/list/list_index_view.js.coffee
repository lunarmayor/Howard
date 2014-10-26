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
      'edit': 'startEdit'
      'dblclick': 'startEdit'
      'keyup input': 'handleKeyUp'
      'blur input': 'updateList'
      'click .arrow-container': -> App.execute('show:list', @model.get('id'))
      'destroy': 'destroyModel'

    onRender: ->
      if @model.get('id')
        @el.style.opacity = 0
        @$el.animate(opacity: 1, 700)
      else
        @el.style.opacity = 1

    startEdit: ->
      @$el.removeClass('selected').addClass('update')
        .html("<input type='text' value='#{@model.get('name')}'/>").find('input').focus()

    handleKeyUp: (e) ->
      if e.keyCode == 13
        @updateList()
    
    updateList: ->
      @model.set('name', @$el.find('input').val())
      @model.save()
      @$el.removeClass('update').html(@model.get('name') + "<div class='arrow-container'>
  <svg class='icon-arrow-icon' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' version='1.1' id='Layer_1' x='0px' y='0px' viewBox='0 0 100 100'>
   <path d='M67,52.1c0.1-0.1,0.1-0.1,0.2-0.2c0,0,0.1-0.1,0.1-0.1c0,0,0,0,0-0.1c0.4-0.5,0.6-1.1,0.6-1.8c0-0.7-0.2-1.3-0.6-1.8  c0,0,0,0-0.1-0.1c0,0,0-0.1-0.1-0.1C67.1,48,67.1,48,67,47.9L53.8,34.6c-1.2-1.2-3.1-1.2-4.2,0c-1.2,1.2-1.2,3.1,0,4.2l8.2,8.2  l-22.6,0c-1.6,0-3,1.3-3,3c0,1.6,1.3,3,3,3l22.6,0l-8.2,8.2c-1.2,1.2-1.2,3.1,0,4.2c1.2,1.2,3.1,1.2,4.2,0L67,52.1  C67,52.1,67,52.1,67,52.1z'></path>
</svg>
</div>")

    dragStart: (e) ->
      $(e.target).animate({opacity: 0.6}, 300)
      dragIcon = document.createElement('img')
      dragIcon.src = 'https://s3.amazonaws.com/howard-app/drag.png'
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
      'blur .new input': 'createList'
      'keyup .new input': 'handleKeyUp'
      'keydown input': 'handleKeyDown'
      'click li': 'select'

    behaviors:
      KeyCommands:
        187: -> @addInput()
        38: -> @selectPrevious()
        40: -> @selectNext()
        84: -> @deleteSelected()
        8: -> @deleteSelected()
        39: -> @goToSelected()
        69: -> @startEdit()

    deleteSelected: ->
      selected = @$el.find('li.selected')

      if selected.length
        selected.trigger('destroy')

    goToSelected: ->
      selected = @$el.find('li.selected')

      if selected.length
        selected.find('.icon-arrow-icon').trigger('click')

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

    startEdit: ->
      @destroyInput()
      selected = @$el.find('li.selected')
      
      if selected.length
        selected.trigger('edit')

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
      else
        @destroyInput()

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
      dragIcon.src = 'https://s3.amazonaws.com/howard-app/drag.png'

      @$el.find('.fa-trash-container').on('dragover', @cancelEvent)
      @$el.find('.fa-trash-container').on('dragleave', @unhighlight)
      @$el.find('.fa-trash-container').on('drop', @handleDrop)

