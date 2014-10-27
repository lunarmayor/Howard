Howard.module "User.Edit", (Edit, App) ->
  
  class Edit.View extends App.Views.ItemView
  	template: 'user/edit/templates/user'

  	events: 
      'click .submit': 'save'
      'click .prompt-yes': -> @setPromptYes()
      'click .prompt-no': -> @setPromptNo()
      'click .destroy': 'destroyUser'

    destroyUser: ->
      return unless confirm('Are you sure you want to delete your account? :(')
      $.ajax
        url: '/users/1'
        type: 'DELETE'
        success: ->
          window.location = '/'

    setPromptYes: ->
      @model.set('prompt', true)
      $('.prompt-options span').removeClass('selected')
      $('.prompt-yes').addClass('selected')

    setPromptNo: ->
      @model.set('prompt', false)
      $('.prompt-options span').removeClass('selected')
      $('.prompt-no').addClass('selected')


    save: ->
      @model.set('phone', @$el.find('.phone').val())
      @model.set('email', @$el.find('.email').val())
      @model.save({}, success: =>
      	@$el.find('.success').animate({opacity: 1}, 500)
      	setTimeout(=>
          @$el.find('.success').animate({opacity: 0}, 500)
        , 2000)
      )

