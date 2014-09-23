do (Backbone, Marionette) ->
  class Marionette.Region.TransitionRegion extends Marionette.Region
    #override show to allow transitions
    show: (view, options) ->
      @_ensureElement()
      showOptions = options or {}
      isDifferentView = view isnt @currentView
      preventDestroy = !!showOptions.preventDestroy
      forceShow = !!showOptions.forceShow

      # we are only changing the view if there is a view to change to begin with
      isChangingView = !!@currentView

      # only destroy the view if we don't want to preventDestroy and the view is different
      _shouldDestroyView = not preventDestroy and isDifferentView
      if  _shouldDestroyView
        if !_.isUndefined(@currentView)
          @currentView.$el.animate({opacity: 0}, 300, =>
            @empty()
            $('#main').scrollTop(0) #use scrollable conatiner instead
            @showView(view, isChangingView) if isDifferentView or forceShow
          )
        else
          @showView(view, isChangingView) if isDifferentView or forceShow
      else
        @

    showView: (view, isChangingView) ->
      # We need to listen for if a view is destroyed
      # in a way other than through the region.
      # If this happens we need to remove the reference
      # to the currentView since once a view has been destroyed
      # we can not reuse it.
      view.once "destroy", => @empty()
      view.render()
      @triggerMethod "before:swap", view  if isChangingView
      @triggerMethod "before:show", view
      if _.isFunction(view.triggerMethod)
        view.triggerMethod "before:show"
      else
        @triggerMethod.call view, "before:show"

      view.el.style.opacity = 0 if isChangingView
      @attachHtml view
      view.$el.animate({opacity: 1}, 400) if isChangingView
      @currentView = view

      @triggerMethod "swap", view  if isChangingView
      @triggerMethod "show", view

      if _.isFunction(view.triggerMethod)
        view.triggerMethod "show"
      else
        @triggerMethod.call view, "show"
      @