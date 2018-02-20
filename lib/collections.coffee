@Cards = new Meteor.Collection 'cards'
@Inventories = new Meteor.Collection 'inventories'
@Decks = new Meteor.Collection 'decks'

Cards.deny(
  insert: ->
    return true

  update: ->
    return true

  remove: ->
    return true
)

# Schemas
InventorySchema = new SimpleSchema
  owner:
    type: String
    label: 'Owner ID'
    autoValue: ->
      if @isInsert
        return Meteor.userId()

  cards:
    type: Object
    label: 'Cards'
    optional: true
    blackbox: true
    defaultValue: ->
      return {}

Inventories.attachSchema InventorySchema
Inventories.allow(
  insert: (userId, doc) ->
    return userId

  update: (userId, doc) ->
    return userId == doc.owner

  remove: (userId, doc) ->
    return userId == doc.owner
)

DeckSchema = new SimpleSchema
  name:
    type: String
    label: 'Name'
    max: 200

  owner:
    type: String
    label: 'Owner ID'
    autoValue: ->
      if @isInsert
        return Meteor.userId()

  active:
    type: Boolean
    label: 'Active'

  description:
    type: String
    optional: true
    label: 'Description'

  cards:
    type: Object
    label: 'Cards'
    optional: true
    blackbox: true
    defaultValue: ->
      return {}

  parent:
    type: String
    optional: true
    label: 'Forked From'

  public:
    type: Boolean
    label: 'Public'
    defaultValue: false

Decks.attachSchema DeckSchema
Decks.allow(
  insert: (userId, doc) ->
    return userId

  update: (userId, doc) ->
    return userId == doc.owner

  remove: (userId, doc) ->
    return userId == doc.owner
)

Decks.helpers

  library: ->
    items = _.map(@cards, (num, id) ->
      card = Cards.findOne(card_id: id)
      if card? and card?.type != 'Vampire' and card?.type != 'Imbued'
        card.deck_count = num
        return card
      else
        return null
    )
    return _.filter(items, (card) ->
      return card?
    )

  crypt: ->
    items = _.map(@cards, (num, id) ->
      card = Cards.findOne(card_id: id)
      if card? and card?.type == 'Vampire' or card?.type == 'Imbued'
        card.deck_count = num
        return card
      else
        return null
    )
    return _.filter(items, (card) ->
      return card?
    )
