Template.card.helpers
  inventoryCount: ->
    card = Inventories.findOne(cardId: @cardId)
    if card
      return card.count
    else
      return 0

  isCryptCard: ->
    return @cardType == 'crypt'
