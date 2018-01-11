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
  action: ->
    @render 'decks', {
      data: ->
        data = {deckModal: 'addDeck'}
        return data
    }

Router.route '/decks/:_id',
  name: 'decks.view'
  controller: AppController
  action: ->
    @render 'deck', {
      data: ->
        return {_id: @params._id}
    }
