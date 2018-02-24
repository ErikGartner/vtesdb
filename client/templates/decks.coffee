Template.decks.helpers
  DeckIndex: ->
    return DeckIndex

  deckModal: ->
    return @deckModal

  loadMoreAttributes: ->
    return {class: "ui green fluid big button"}

  decks: ->
    return Decks.find()

Template.deckResult.helpers
  cardCount: ->
    return _.reduce(_.map(@cards, (v, k) -> return v), (v, m) ->
      return v + m
    , 0)

  deckId: ->
    if @__originalId?
      return @__originalId
    else
      return @_id

  deckImage: ->
    # Picks the most common card in the deck as the image
    cards = _.sortBy _.pairs(@cards), (c) -> return c[1]
    return _.last(cards)[0]
