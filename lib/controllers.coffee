@AppController = RouteController.extend(layoutTemplate: 'appLayout')

@CardsController = AppController.extend(
  template: 'cards'
)

@InventoryController = AppController.extend(
  template: 'inventory'
)
