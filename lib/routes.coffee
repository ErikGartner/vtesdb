@AppController = RouteController.extend(layoutTemplate: 'appLayout')

Router.configure
  controller: 'AppController'
  trackPageView: true

Router.route '/',
  name: 'home'
  template: 'cards'

Router.route '/s/:searchString',
  name: 'searchCard'
  template: 'cards'
  data: ->
    return {searchString: @params.searchString}

Router.route '/import',
  name: 'import'
  template: 'import'

Router.route '/decks',
  name: 'decks'
  template: 'decks'

Router.route '/decks/add',
  name: 'decks.add'
  template: 'addDeck'

Router.route '/decks/view/:_id',
  name: 'decks.view'
  template: 'deck'
  data: ->
    return Decks.findOne(@params._id)
  subscriptions: ->
    return @subscribe 'deck', @params._id

Router.route '/decks/edit/:_id',
  name: 'decks.edit'
  template: 'editDeck'
  data: ->
    return Decks.findOne(@params._id)
  subscriptions: ->
    return @subscribe 'deck', @params._id

Router.route '/decks/simulate/:_id',
  name: 'deck.simulator'
  template: 'simulator'
  data: ->
    return Decks.findOne(@params._id)
  waitOn: ->
    # We wait on the subscription otherwise the
    # simulator can't to setup the deck.
    return @subscribe 'deck', @params._id
