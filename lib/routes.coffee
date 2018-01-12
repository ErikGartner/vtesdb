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

Router.route '/deck/:_id',
  name: 'decks.view'
  controller: AppController
  action: ->
    @render 'deck', {
      data: ->
        return {_id: @params._id}
    }
