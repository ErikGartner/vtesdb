Router.route '/',
  name: 'home'
  controller: 'CardsController'

Router.route '/import',
  name: 'import'
  controller: 'ImportController'

Router.route '/decks',
  name: 'decks'
  controller: 'DecksController'

Router.route '/decks/add',
  name: 'decks.add'
  controller: 'DecksController'
  template: 'addDeck'

Router.route '/decks/view/:_id',
  name: 'decks.view'
  controller: AppController
  action: ->
    @render 'deck', {
      data: ->
        return Decks.findOne(@params._id)
    }

Router.route '/decks/edit/:_id',
  name: 'decks.edit'
  controller: AppController
  action: ->
    @render 'editDeck', {
      data: ->
        return Decks.findOne(@params._id)
    }
