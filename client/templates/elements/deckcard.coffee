Template.cardSearch.helpers
  ShortCardsIndex: ->
    return ShortCardsIndex

  loadMoreAttributes: ->
    return {class: "ui green fluid button"}

  inputAttributes: ->
    return {id: 'card-search-input'}

Template.deckCard.events

  'submit .set-card': (event) ->
    id = event.target.id.value
    deck = Router.current().params._id
    count = parseInt(event.target.count.value)
    Meteor.call 'setDeckCard', id, deck, count
    return false

Template.deckCard.helpers
  isCryptCard: ->
    return @type == 'Vampire' or @type == 'Imbued'

  cardCount: ->
    deck = Router.current().params._id
    count = Decks.findOne(deck).cards[@card_id]
    if count?
      return count
    else
      return 0
