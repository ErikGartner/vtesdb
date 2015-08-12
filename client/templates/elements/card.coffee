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
