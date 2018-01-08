Template.decks.helpers
  deckModal: ->
    return @deckModal

Template.deckSearch.helpers
  decks: ->
    return Decks.find()

Template.deck.helpers
  deck: ->
    return Decks.findOne(@_id)

  libItems: ->
    items = Decks.findOne(@_id).library()
    return _.sortBy(items, ['name'])

  cryptItems: ->
    items = Decks.findOne(@_id).crypt()
    return _.sortBy(items, ['name'])

Template.decks.onRendered ->
  $('.ui.dropdown').dropdown()

Template.deckSearch.events
  'change #selected_deck': (event) ->
    if event.target.value?
      Router.go 'decks.view', {_id: event.target.value}
