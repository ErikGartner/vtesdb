@Cards = new (Meteor.Collection)('cards')
@Inventories = new (Meteor.Collection)('inventories')
@Decks = new (Meteor.Collection)('decks')
@DeckCards = new (Meteor.Collection)('deckCards')
@Version = new (Meteor.Collection)('version')

Cards.initEasySearch 'name',
  'limit': 12
  'use': 'mongo-db'
