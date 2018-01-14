@Cards = new Meteor.Collection 'cards'
@Inventories = new Meteor.Collection 'inventories'
@Decks = new Meteor.Collection 'decks'
@Version = new Meteor.Collection 'version'
@Rulings = new Meteor.Collection 'rulings'

# Schemas
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
    autoValue: ->
      if @isInsert
        return {}


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
      if card?.card_type == 'lib'
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
      if card?.card_type == 'crypt'
        card.deck_count = num
        return card
      else
        return null
    )
    return _.filter(items, (card) ->
      return card?
    )
