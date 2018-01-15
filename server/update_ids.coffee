Meteor.startup ->
  mapping = JSON.parse(Assets.getText('update_mapping.json'))
  Inventories.find().forEach (doc) ->
    if mapping[doc.cardId]?
      doc['cardId'] = mapping[doc.cardId]
      Inventories.update doc['_id'], doc

  Decks.find().forEach (doc) ->
    cards = doc.cards
    keys = Object.keys(cards)
    new_cards = {}
    _.each keys, (key) ->
      if mapping[key]?
        new_cards[mapping[key]] = cards[key]
      else
        new_cards[key] = cards[key]

    Decks.update doc['_id'], $set: 'cards': new_cards
    console.log 'Updated all ids'
