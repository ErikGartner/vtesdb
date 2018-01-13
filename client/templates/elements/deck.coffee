Template.deck.helpers

  libItems: ->
    items = Decks.findOne(@_id).library()
    return _.sortBy(items, ['name'])

  cryptItems: ->
    items = Decks.findOne(@_id).crypt()
    return _.sortBy(items, ['name'])

  stats: ->
    return {
      libCount: Decks.findOne(@_id).library().length
      cryptCount: Decks.findOne(@_id).crypt().length
    }
