Meteor.methods
  validCard: (cardId) ->
    check cardId, String
    if Meteor.isServer
      Cards.find('cardId': cardId).count() == 1
    else
      # Client assums valid cardId. This allows for latency comp.
      return true

  setInv: (id, count) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')
    check count, Match.Integer
    check id, String
    if count < 0
      return
    if !Meteor.call('validCard', id)
      throw new Meteor.Error('invalid card id')
    if count > 0
      Inventories.upsert {
        cardId: id
        owner: uid
      },
        'count': count
        cardId: id
        owner: uid
    else
      Inventories.remove cardId: id
    return

  addDeck: (deckName) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')
    check deckName, String
    if Decks.findOne('deckName': deckName.toLowerCase())
      throw new (Meteor.Error)('deck-exists')
    deckId = Decks.insert(
      'deckName': deckName.toLowerCase()
      owner: uid)
    return deckId

  setDeckCard: (deckId, cardId, count) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')
    check cardId, String
    check count, Match.Integer
    check deckId, String
    if count < 0
      return
    if !Meteor.call('validCard', cardId)
      throw new Meteor.Error('invalid card id')
    if count > 0
      DeckCards.upsert {
        'deckId': deckId
        'cardId': cardId
      },
        'deckId': deckId
        'cardId': cardId
        deckCount: count
        owner: uid
    else
      DeckCards.remove
        'deckId': deckId
        'cardId': cardId
      if DeckCards.find('deckId': deckId).count() == 0
        Decks.remove _id: deckId
    return

  idFromName: (name, adv) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')
    check name, String
    check adv, String
    if adv != ''
      card = Cards.findOne('name': name, 'adv': adv)
    else
      card = Cards.findOne('name': name)
    if card?
      return card['cardId']
    else
      return -1
