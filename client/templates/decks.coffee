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
    library = Decks.findOne(@_id).library
    count = _.countBy(library)
    items = _.map(_.uniq(library), (id) ->
      card = Cards.findOne(cardId: id)
      card.deck_count = count[id]
      return card
    )
    return _.sortBy(items, ['name'])

  cryptItems: ->
    library = Decks.findOne(@_id).crypt
    count = _.countBy(library)
    items = _.map(_.uniq(library), (id) ->
      card = Cards.findOne(cardId: id)
      card.deck_count = count[id]
      return card
    )
    return _.sortBy(items, ['name'])

Template.decks.onRendered ->
  $('.ui.dropdown').dropdown()

Template.deckSearch.events
  'change #selected_deck': (event) ->
    if event.target.value?
      Router.go 'decks.view', {_id: event.target.value}
