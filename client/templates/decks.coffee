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
