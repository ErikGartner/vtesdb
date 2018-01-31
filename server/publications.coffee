Meteor.publish 'inventories', ->
  Inventories.find owner: @userId

Meteor.publish 'version', ->
  Version.find()

Meteor.publish 'rulings', ->
  Rulings.find()

# Get all data associated with a users deck
# To make more efficient, request only one deck at a time.
Meteor.publishComposite 'decks', ->
  find: ->
    user = Meteor.users.findOne _id: @userId
    if user?
      return Decks.find {owner: @userId}
    else
      return @ready()

  children: [
    {
      find: (deck) ->
        cards = Object.keys(deck.cards)
        return Cards.find card_id: $in: cards
    }
  ]


# Setup the indices
Meteor.startup ->
  # Most important is an index for the Cards since they are searched
  # on the server.
  Cards._ensureIndex {norm_name: 1, name: 1, type: 1, disciplines: 1, text: 1}
