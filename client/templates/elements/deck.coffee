Template.deck.helpers
  deck: ->
    return Decks.findOne(@_id)

  libItems: ->
    items = Decks.findOne(@_id).library()
    return _.sortBy(items, ['name'])

  cryptItems: ->
    items = Decks.findOne(@_id).crypt()
    return _.sortBy(items, ['name'])

  stats: ->
    return {
      libCount: Decks.findOne(@_id).library().length
      cryptCount: Decks.findOne(@_id).crypt().length
    }

Template.cardSearch.helpers
  CardsIndex: ->
    return CardsIndex

  loadMoreAttributes: ->
    return {class: "ui green button"}

Template.bareCard.events

  'submit .set-card': (event) ->
    id = event.target.id.value
    deck = Router.current().params._id
    count = parseInt(event.target.count.value)
    Meteor.call 'setDeckCard', id, deck, count
    return false

Template.bareCard.helpers
  cardCount: ->
    deck = Router.current().params._id
    count = Decks.findOne(deck).cards[@cardId]
    if count?
      return count
    else
      return 0
