Meteor.methods
  validCard: (card_id) ->
    check card_id, String
    if Meteor.isServer
      return Cards.findOne('card_id': card_id)?
    else
      # Client assums valid card_id. This allows for latency comp.
      return true

  setInv: (card_id, count) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')

    check card_id, String
    check count, Match.Integer

    if count < 0
      return

    inv = Inventories.findOne owner: uid

    if Meteor.isServer
      # Validate the card id but only on the server side
      card = Cards.findOne card_id: card_id
      if not card?
        throw new Meteor.Error('invalid-card')

    if count == 0
      delete inv.cards[card_id]
    else
      inv.cards[card_id] = count
    Inventories.update inv._id, $set: cards: inv.cards
    return

  setDeckCard: (card_id, deckId, count) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')

    check card_id, String
    check count, Match.Integer
    check deckId, String

    if count < 0
      return

    if Meteor.isServer
      card = Cards.findOne(card_id: card_id)
      if not card?
        throw new Meteor.Error('invalid-card')

    deck = Decks.findOne(_id: deckId, owner: uid)
    if not deck?
      throw new Meteor.Error('invalid deck')

    if count == 0
      delete deck.cards[card_id]
    else
      deck.cards[card_id] = count
    Decks.update deckId, $set: cards: deck.cards
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
      selector = norm_name: "#{name} (adv)"
    else
      selector = norm_name: name

    if Meteor.isClient
      return -2

    card = Cards.findOne selector
    if not card?
      return -1

    card_id = card.card_id

    inv = Inventories.findOne owner: uid
    inv = if inv? then inv else {owner: uid, cards: {}}

    current_count = if inv.cards[card_id]? then inv.cards[card_id] else 0
    inv.cards[card_id] = current_count + count
    Inventories.upsert {owner: uid}, $set: cards: inv.cards
    return card_id

  forkDeck: (deckId) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')

    check deckId, String

    deck = Decks.findOne {$and: [{_id: deckId}, {$or: [{owner: uid},
                                                       {public: true}]}]}
    if not deck?
      throw new Meteor.Error('invalid deck')

    delete deck['_id']
    deck.name = deck.name + ' (forked)'
    deck.parent = deckId
    deck.active = false
    deck.owner = uid

    return Decks.insert(deck)
