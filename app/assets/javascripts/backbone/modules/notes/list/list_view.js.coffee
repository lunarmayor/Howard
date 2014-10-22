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
      'destroy': 'destroyModel'
      'edit': 'startEdit'
      'dblclick': 'startEdit'
      'add:to:list': 'addToList'
      'blur input': 'updateNote'
      'keyup input': 'handleKeyUp'

    startEdit: ->
      @$el.removeClass('selected').addClass('update').html("<input type='text' value='#{@model.get('content')}'/>").find('input').focus()

    handleKeyUp: (e) ->
      if e.keyCode == 13
        @updateNote()

    updateNote: ->
      @model.set('content', @$el.find('input').val())
      @model.save()
      @$el.removeClass('update').html(@model.get('content'))

    addToList: (e, listIndex) ->
      return if listIndex is '0'
      listId = App.request('list:id:at:index', listIndex)
      
      if listId and @model.get('list_id') != listId
        @model.set('list_id', listId)
        @model.save(null, {slient: true, success: =>
          App.execute('highlight:list', listId)
          @model.collection.remove(@model)
        })
    
    destroyModel: ->
      @model.destroy()
   
    tempHide: (e) ->
      $(e.target).animate({opacity: 0.6}, 300)
      dragIcon = document.createElement('img')
      dragIcon.src = 'https://s3.amazonaws.com/howard-app/drag.png'
      $(dragIcon).addClass('drag-icon')
      e.originalEvent.dataTransfer.setDragImage(dragIcon, 0, 0)

      e.originalEvent.dataTransfer.setData('Text', @model.get('id'))
    
    dragging: (e) ->
      e.preventDefault()

    tempShow: (e) ->
      $(e.target).animate({opacity: 1}, 300)

    onRender: ->
      if @model.get('id')
        @el.style.opacity = 0
        @$el.animate(opacity: 1, 700)
      else
        @el.style.opacity = 1

  class List.View extends App.Views.CompositeView
    template: 'notes/list/templates/list'
    childView: List.ListItem
    className: 'note-list'
    childViewContainer: 'ul'
    currentNumber: ''

    events:
      'click .fa-plus': 'addInput'
      'blur .new input': 'createNote'
      'keyup .new input': 'handleKeyUp'
      'keydown .new input': 'handleKeyDown'
      'click li': 'select'

    behaviors:
      KeyCommands:
        187: -> @addInput()
        37: -> @goToLists()
        38: -> @selectPrevious()
        40: -> @selectNext()
        84: -> @deleteSelected()
        8: -> @deleteSelected()
        69: -> @startEdit()
        48: ->
          @changeCurrentNumber(0)
          @addToList()
        49: -> 
          @changeCurrentNumber(1)
          @addToList()
        50: -> 
          @changeCurrentNumber(2)
          @addToList()
        51: ->
          @changeCurrentNumber(3)
          @addToList()
        52: ->
          @changeCurrentNumber(4)
          @addToList()
        53: ->
          @changeCurrentNumber(5)
          @addToList()
        54: ->
          @changeCurrentNumber(6)
          @addToList()
        55: ->
          @changeCurrentNumber(7)
          @addToList()
        56: ->
          @changeCurrentNumber(8)
          @addToList()
        57: ->
          @changeCurrentNumber(9)
          @addToList()
        96: ->
          @changeCurrentNumber(0)
          @addToList()
        97: -> 
          @changeCurrentNumber(1)
          @addToList()
        98: -> 
          @changeCurrentNumber(2)
          @addToList()
        99: ->
          @changeCurrentNumber(3)
          @addToList()
        100: ->
          @changeCurrentNumber(4)
          @addToList()
        101: ->
          @changeCurrentNumber(5)
          @addToList()
        102: ->
          @changeCurrentNumber(6)
          @addToList()
        103: ->
          @changeCurrentNumber(7)
          @addToList()
        104: ->
          @changeCurrentNumber(8)
          @addToList()
        105: ->
          @changeCurrentNumber(9)
          @addToList()
        preventDefault: [187]

    addToList: _.debounce((-> @addToListAndRemove()) , 400)

    changeCurrentNumber: (number) ->
      @currentNumber += number

    addToListAndRemove: ->
      @$el.find('li.selected').trigger('add:to:list', @currentNumber)
      @currentNumber = ''
    
    deleteSelected: ->
      selected = @$el.find('li.selected')

      if selected.length
        selected.trigger('destroy')

    goToLists: ->
      App.execute('index:list')

    select: (e) ->
      unless $(e.currentTarget).find('input').length
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
        @createNote()
    
    handleKeyDown: (e) ->
      if e.keyCode == 8 and @$el.find('input').val() == ""
        @destroyInput()

    createNote: ->
      value = @$el.find('input').val()

      if value != ''
        note = App.request('new:note:entity')
        note.set('content', value)
        note.set('list_id', @model.get('id')) if !_.isUndefined(@model)
        @$el.find('li.new').remove()
        @collection.add(note)
        note.save({}, {silent: true})
        @$el.find('.fa-plus').show()
      else
        @destroyInput()

    startEdit: ->
      @destroyInput()
      selected = @$el.find('li.selected')
      
      if selected.length
        selected.trigger('edit')

    destroyInput: ->
      @$el.find('li.new').animate({opacity: 0}, 400, =>
        @$el.find('li.new').remove() if @$el.find('li.new').length
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
      
      socket = io.connect('http://stark-forest-1884.herokuapp.com/')
      
      channel = 'message:' + gon.phone

      socket.on(channel, (data) =>
        console.log(data)
        if _.isUndefined(@model) and _.isNull(data.list_id)
          @collection.add(data)
        else
          @collection.add(data) if @model.get('id') == data.list_id
      )

      @$el.find('.fa-trash-container').on('dragover', @cancelEvent)
      @$el.find('.fa-trash-container').on('dragleave', @unhighlight)
      @$el.find('.fa-trash-container').on('drop', @handleDrop)
