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

Template.registerHelper 'deckStats', ->
  sum = (list) ->
    list = _.map(list, (l) ->
      return l.deck_count
    , 0)
    return _.reduce(list, (m, n) ->
      return m + n
    , 0)
  return {
    libCount: sum(_.values(Decks.findOne(@_id).library()))
    cryptCount: sum(_.values(Decks.findOne(@_id).crypt()))
  }
