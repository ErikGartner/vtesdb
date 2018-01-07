@Cards = new Meteor.Collection 'cards'
@Inventories = new Meteor.Collection 'inventories'
@Decks = new Meteor.Collection 'decks'
@Version = new Meteor.Collection 'version'
@Rulings = new Meteor.Collection 'rulings'

@CardsIndex = new EasySearch.Index
  collection: Cards
  limit: 12
  fields: ['norm_name']
  engine: new EasySearch.MongoDB()

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

  crypt:
    type: [String]
    label: 'Crypt cards'
    autoValue: ->
      if @isInsert
        return []

  library:
    type: [String]
    label: 'Library cards'
    autoValue: ->
      if @isInsert
        return []

Decks.attachSchema DeckSchema
Decks.allow(
  insert: (userId, doc) ->
    return userId

  update: (userId, doc) ->
    return userId == doc.owner

  remove: (userId, doc) ->
    return userId == doc.owner
)
