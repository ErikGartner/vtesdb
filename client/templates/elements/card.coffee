Template.card.helpers
  inventoryCount: ->
    card = Inventories.findOne(cardId: @cardId)
    if card
      return card.count
    else
      return 0

  isCryptCard: ->
    return @cardType == 'crypt'

Template.card.rendered = ->
  $('.special.card .image').dimmer(on: 'hover')
  $('.inventory-button').popup(inline: true, on: 'click')

Template.card.events
  'submit .set-inv': (event) ->
    id = event.target.id.value
    count = parseInt(event.target.count.value)
    Meteor.call 'setInv', id, count
    $('.inventory-button').popup 'hide all'
    return false

  'click .inventory-button': (event) ->
    $('.badge-input').focus()
