Meteor.publish 'inventories', ->
  Inventories.find owner: @userId

Meteor.publish 'decks', ->
  Decks.find owner: @userId

Meteor.publish 'deckCards', ->
  DeckCards.find owner: @userId
  
Meteor.publish 'version', ->
  Version.find()
