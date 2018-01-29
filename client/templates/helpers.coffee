Template.registerHelper 'deckStats', ->
  sum = (list) ->
    list = _.map(list, (l) ->
      return l.deck_count
    , 0)
    return _.reduce(list, (m, n) ->
      return m + n
    , 0)
  deck = Decks.findOne(@_id)
  if not deck?
    return {}
  else
    return {
      libCount: sum(_.values(deck.library()))
      cryptCount: sum(_.values(deck.crypt()))
    }

Template.registerHelper 'renderCardText', (text) ->
  return text
