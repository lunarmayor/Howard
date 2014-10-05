Howard.module 'Behaviors', (Behaviors, App) ->
  
  class Behaviors.KeyCommands extends Marionette.Behavior

  	defaults: 
      preventDefault: []

    onShow: ->
      $(window).on 'keydown', @checkKey

    onDestroy: ->
      $(window).off 'keydown', @checkKey
    
    shouldIgnore: ->
      a = document.activeElement.tagName
      return true if a is 'INPUT' or a is 'TEXTAREA'

    checkKey: (e) =>
      return if @shouldIgnore()
      e.preventDefault()

      if toInvoke = @options[e.keyCode]
        fn = toInvoke.call(@view, e)

      if ~@options.preventDefault.indexOf(e.keyCode)
        e.preventDefault()
        return false
    
