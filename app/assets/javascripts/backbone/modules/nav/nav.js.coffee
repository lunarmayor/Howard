Howard.module "Nav", (Nav) ->

  API =
    setupNav: ->
      Nav.List.Controller.setupNav()

  Nav.on 'start', ->
    API.setupNav()