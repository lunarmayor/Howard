Howard.module "Entities", (Entities, App) ->

  class Entities.NavLink extends Entities.Model

  class Entities.NavLinkCollection extends Entities.Collection
    model: Entities.NavLink

  API =
    getNavLinks: ->
      new Entities.NavLinkCollection [
        { title: "brain dump", url: '/brain_dump' }
        { title: "lists", url: '/lists' }
        { title: "config", url: '/config' }
      ]

  App.reqres.setHandler "nav:entities", ->
    API.getNavLinks()