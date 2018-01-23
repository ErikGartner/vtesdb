Meteor.methods
  validCard: (card_id) ->
    check card_id, String
    if Meteor.isServer
      return Cards.findOne('card_id': card_id)?
    else
      # Client assums valid card_id. This allows for latency comp.
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
        card_id: id
        owner: uid
      },
        count: count
        card_id: id
        owner: uid
    else
      Inventories.remove card_id: id
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

    if not Meteor.isServer
      return true

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
      selector = 'norm_name': name, 'adv': adv
    else
      selector = 'norm_name': name

    card = Cards.findOne(selector)
    if not card?
      return -1
    id = card.card_id

    inv = Inventories.findOne {cardId: id, owner: uid}
    if inv?
      Inventories.update {_id:inv._id}, {$inc: {count: count}}
    else
      Inventories.insert {cardId: id, owner: uid, count: count}

    return id
