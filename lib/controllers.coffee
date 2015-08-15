@AppController = RouteController.extend(layoutTemplate: 'appLayout')

@CardsController = AppController.extend(
  template: 'cards'
)

@ImportController = AppController.extend(
  template: 'import'
)

@DecksController = AppController.extend(
  template: 'decks'
)
