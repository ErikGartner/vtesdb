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
    return @type == 'Vampire'

  cardCount: ->
    deck = Router.current().params._id
    count = Decks.findOne(deck).cards[@card_id]
    if count?
      return count
    else
      return 0

  inventoryCount: ->
    card = Inventories.findOne(cardId: @card_id)
    if card?
      card_id = @card_id
      used = Decks.find(owner: Meteor.userId, active: true).map (doc) ->
        return if doc.cards[card_id]? then doc.cards[card_id] else 0
      used = _.reduce(used, (memo, num) ->
        return memo + num
      , 0)
      return {inv: card.count, used: used}
    else
      return {inv: 0, used: 0}
