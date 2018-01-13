Template.card.helpers
  inventoryCount: ->
    card = Inventories.findOne(cardId: @cardId)
    if card?
      return card.count
    else
      return 0

  isCryptCard: ->
    return @cardType == 'crypt'

  rulings: ->
    rulings = Rulings.findOne(id: @cardId)
    return rulings?.rulings

Template.card.onRendered ->
  $('.special.card .image').dimmer(on: 'hover')
  $('.inventory-button').popup(popup: '.inv.popup', on: 'click')
  $('.rulings-icon').popup(inline: true, on: 'hover')

Template.card.events
  'submit .set-inv': (event) ->
    id = event.target.id.value
    count = parseInt(event.target.count.value)
    Meteor.call 'setInv', id, count
    $('.inventory-button').popup 'hide all'
    return false

  'click .inventory-button': (event) ->
    $('.badge-input').focus()

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
