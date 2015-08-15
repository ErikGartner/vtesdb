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

  importCardByName: (name, adv, count) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')
    check name, String
    check adv, String
    check count, Match.Integer
    if count < 0
      throw new Meteor.Error('negative-count')

    name = name.toLowerCase()
    if adv != ''
      selector = 'norm_name': name, 'adv': adv
    else
      selector = 'norm_name': name

    card = Cards.findOne(selector)
    if not card?
      return -1
    id = card.cardId

    inv = Inventories.findOne {cardId: id, owner: uid}
    if inv?
      Inventories.update {_id:inv._inv}, {$inc: {count: count}}
    else
      Inventories.insert {cardId: id, owner: uid, count: count}

    return id
