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
  return "http://rover.ebay.com/rover/1/711-53200-19255-0/1?icep_ff3=9&pub=5575368791&toolid=10001&campid=5338254452&customid=&icep_uq=vtes+#{cardName}"
