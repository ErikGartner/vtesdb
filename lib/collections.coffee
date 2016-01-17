@Cards = new Meteor.Collection 'cards'
@Inventories = new Meteor.Collection 'inventories'
@Decks = new Meteor.Collection 'decks'
@DeckCards = new Meteor.Collection 'deckCards'
@Version = new Meteor.Collection 'version'
@Rulings = new Meteor.Collection 'rulings'

@CardsIndex = new EasySearch.Index
  collection: Cards
  limit: 12
  fields: ['norm_name']
  engine: new EasySearch.MongoDB()
