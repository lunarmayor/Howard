Howard.module 'Nav.List', (List, App) ->
  class List.NavLink extends App.Views.ItemView
    template: 'nav/list/templates/_nav_link'
    tagName: 'li'
    events:
      'click': ->
        @trigger('change:route', @model)

  class List.Nav extends App.Views.CompositeView
    template: 'nav/list/templates/nav'
    childView: List.NavLink
    childViewContainer: 'ul'
    events:
      'click .logo': -> @trigger('visit:root')
