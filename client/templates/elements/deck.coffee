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


Template.editDeck.helpers
  beforeRemove: ->
    return (collection, id) ->
      doc = collection.findOne id
      if confirm('Really delete "' + doc.name + '"?')
        this.remove()
