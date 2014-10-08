Howard.module 'User.Edit', (Edit, App) ->

  Edit.Controller =
    editUser: ->
      promise = App.request('currentUser:entity')
      $.when(promise).then( (user) ->
        user = new App.Entities.User(user)
        userView = new Edit.View({model: user})
        App.mainRegion.show(userView)
      )

