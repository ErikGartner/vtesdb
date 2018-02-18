Template.registerHelper 'deckStats', ->
  deck = Decks.findOne(@_id)
  if not deck?
    return {}

  countDeckCards = (list) ->
    list = _.map(list, (l) ->
      return l.deck_count
    , 0)
    return _.reduce(list, (m, n) ->
      return m + n
    , 0)

  return {
    libCount: countDeckCards(_.values(deck.library()))
    cryptCount: countDeckCards(_.values(deck.crypt()))
  }

Template.registerHelper 'renderCardText', (text) ->
  return text

Template.registerHelper 'buyLink', (cardName) ->
  return "http://rover.ebay.com/rover/1/711-53200-19255-0/1?icep_ff3=9&" +
         "pub=5575368791&toolid=10001&campid=5338254452" +
         "&customid=&icep_uq=vtes+#{cardName}"

Template.registerHelper 'inventoryStatus', (card_id) ->

  card = Inventories.findOne(card_id: card_id)
  inventory = if card? then card.count else 0

  # Find active decks that use the card
  inDecks = Decks.find {owner: Meteor.userId(), active: true, "cards.#{card_id}": $gt: 0}

  # Total the amount used
  used = inDecks.map (doc) ->
    return doc.cards[card_id]

  used = _.reduce(used, (memo, num) ->
    return memo + num
  , 0)

  missing = if used > inventory then used - inventory else false
  deckNames = inDecks.map (d) -> return {name: d.name, count: d.cards[card_id]}
  return {card_id: card_id, inv: inventory, used: used, missing: missing, in_decks: deckNames}
