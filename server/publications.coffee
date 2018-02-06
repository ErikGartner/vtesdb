Meteor.publish 'inventory', ->
  Inventories.find owner: @userId

Meteor.publish 'privateDecks', ->
  return Decks.find {owner: @userId}

# Get all data associated with a public or owned deck
Meteor.publishComposite 'deck', (deckId) ->
  check(deckId, String)

  find: ->
    return Decks.find {$and: [{_id: deckId}, {$or: [{owner: @userId},
                                                    {public: true}]}]}

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
  Cards._ensureIndex norm_name: 1
  Cards._ensureIndex name: 1
  Cards._ensureIndex type: 1
  Cards._ensureIndex disciplines: 1
  Cards._ensureIndex text: "text"
