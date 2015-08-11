Router.plugin 'ensureSignedIn', only: []

Router.route '/',
  name: 'cards'
  controller: 'CardsController'
