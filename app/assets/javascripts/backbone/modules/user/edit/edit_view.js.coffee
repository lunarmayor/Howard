Howard.module "User.Edit", (Edit, App) ->
  
  class Edit.View extends App.Views.ItemView
  	template: 'user/edit/templates/user'