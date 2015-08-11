@AppController = RouteController.extend(layoutTemplate: 'appLayout')

@CardsController = AppController.extend(
  template: 'cards'
  onAfterAction: ->
    Meta.setTitle ''
)
