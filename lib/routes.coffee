@AppController = RouteController.extend(layoutTemplate: 'appLayout')

Router.configure
  controller: 'AppController'

Router.route '/',
  name: 'home'
  template: 'cards'

Router.route '/s/:searchString',
  name: 'searchCard'
  action: ->
    @render 'cards', {
      data: ->
        return {searchString: @params.searchString}
    }

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
  action: ->
    @render 'deck', {
      data: ->
        return Decks.findOne(@params._id)
    }

Router.route '/decks/edit/:_id',
  name: 'decks.edit'
  action: ->
    @render 'editDeck', {
      data: ->
        return Decks.findOne(@params._id)
    }

Router.route '/decks/simulate/:_id',
  name: 'deck.simulator'
  #layoutTemplate: ''
  waitOn: ->
    return Meteor.subscribe 'decks'

  action: ->
    @render 'simulator', {
      data: ->
        return Decks.findOne(@params._id)
    }
