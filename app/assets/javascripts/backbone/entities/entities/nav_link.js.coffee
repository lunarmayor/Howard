Howard.module "Entities", (Entities, App) ->

  class Entities.NavLink extends Entities.Model

  class Entities.NavLinkCollection extends Entities.Collection
    model: Entities.NavLink

  API =
    getNavLinks: ->
      new Entities.NavLinkCollection [
        { title: "brain dump", url: '/brain_dump', src: "https://d30y9cdsu7xlg0.cloudfront.net/png/817-84.png", width: '60', style: 'margin-bottom: -17px' }
        { title: "lists", url: '/lists', src: "https://d30y9cdsu7xlg0.cloudfront.net/png/48225-84.png", width: '80', style: '' }
        { title: "config", url: '/config', src: "https://d30y9cdsu7xlg0.cloudfront.net/png/14513-84.png", width: '50', style: '' }
      ]

  App.reqres.setHandler "nav:entities", ->
    API.getNavLinks()