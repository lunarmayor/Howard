Howard.module 'Nav.List', (List, App) ->

  List.Controller =
    setupNav: ->
      navView = new List.Nav({collection: @getLinks()})

      navView.on 'childview:change:route', (cv, model) ->
        App.vent.trigger('change:route', model)

      navView.on 'visit:root', (cv, model) ->
        App.vent.trigger('visit:root')

      App.navRegion.show(navView)


    getLinks: ->
      App.request "nav:entities"