Template.cardSearch.helpers
  ShortCardsIndex: ->
    return ShortCardsIndex

  loadMoreAttributes: ->
    return {class: "ui green fluid button"}

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
