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
  isCryptCard: ->
    return @cardType == 'crypt'

  cardCount: ->
    deck = Router.current().params._id
    count = Decks.findOne(deck).cards[@cardId]
    if count?
      return count
    else
      return 0

  inventoryCount: ->
    card = Inventories.findOne(cardId: @cardId)
    if card?
      cardId = @cardId
      used = Decks.find(owner: Meteor.userId, active: true).map (doc) ->
        return if doc.cards[cardId]? then doc.cards[cardId] else 0
      used = _.reduce(used, (memo, num) ->
        return memo + num
      , 0)
      return {inv: card.count, used: used}
    else
      return {inv: 0, used: 0}
