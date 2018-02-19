Template.card.helpers
  inventoryCount: ->
    inv = Inventories.findOne owner: Meteor.userId()
    if inv?
      return if inv.cards[@card_id]? then inv.cards[@card_id] else 0
    else
      return 0

  isCryptCard: ->
    return @type == 'Vampire'

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
