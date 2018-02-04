Template.card.helpers
  inventoryCount: ->
    card = Inventories.findOne(cardId: @card_id)
    if card?
      return card.count
    else
      return 0

  isCryptCard: ->
    return @type == 'Vampire'

  rulings: ->
    rulings = Rulings.findOne(id: @card_id)
    return rulings?.rulings

Template.card.onRendered ->
  $('.inventory-button').popup(popup: '.inv.popup', on: 'click')
  $('.rulings-icon').popup(inline: true, on: 'hover')
  $('.special.card .image').dimmer(on: 'hover')

Template.card.events
  'submit .set-inv': (event) ->
    id = event.target.id.value
    count = parseInt(event.target.count.value)
    Meteor.call 'setInv', id, count
    $('.inventory-button').popup 'hide all'
    return false

  'click .inventory-button': (event) ->
    $('.badge-input').focus()
