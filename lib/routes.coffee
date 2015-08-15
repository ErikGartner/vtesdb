Router.route '/',
  name: 'home'
  controller: 'CardsController'

Router.route '/import',
  name: 'import'
  controller: 'ImportController'

Router.route '/decks',
  name: 'decks'
  controller: 'DecksController'
