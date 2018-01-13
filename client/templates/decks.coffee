Template.decks.helpers
  DeckIndex: ->
    return DeckIndex

  deckModal: ->
    return @deckModal

  loadMoreAttributes: ->
    return {class: "ui green fluid big button"}


Template.deckResult.helpers
  stats: ->
    sum = (list) ->
      list = _.map(list, (l) ->
        return l.deck_count
      )
      return _.reduce(list, (m, n) ->
        return m + n
      )
    return {
      libCount: sum(_.values(Decks.findOne(@_id).library()))
      cryptCount: sum(_.values(Decks.findOne(@_id).crypt()))
    }
