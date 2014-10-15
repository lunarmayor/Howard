Howard.module "User.Edit", (Edit, App) ->
  
  class Edit.View extends App.Views.ItemView
  	template: 'user/edit/templates/user'

  	events: 
      'click .submit': 'save'

    save: ->
      @model.set('phone', @$el.find('.phone').val())
      @model.set('email', @$el.find('.email').val())
      @model.save({}, success: =>
      	@$el.find('.success').animate({opacity: 1}, 500)
      	setTimeout(=>
          @$el.find('.success').animate({opacity: 0}, 500)
        , 2000)
      )

