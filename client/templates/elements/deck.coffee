Template.deck.helpers

  libItems: ->
    deck = Decks.findOne(@_id)
    if not deck?
      return []
    items = deck.library()
    items = _.groupBy(items, (item) -> return item.type)
    items = _.map(items, (val, key) -> return {type: key, cards: val})
    return _.sortBy(items, ['type'])

  cryptItems: ->
    deck = Decks.findOne(@_id)
    if not deck?
      return []
    items = deck.crypt()
    return _.sortBy(items, ['name'])

  stats: ->
    return {
      libCount: Decks.findOne(@_id).library().length
      cryptCount: Decks.findOne(@_id).crypt().length
    }

  countCards: (cards) ->
    counts = _.map(cards, (card) -> return card.deck_count)
    return _.reduce(counts, (m, n) -> return m + n)

Template.deck.events

  'click a.card-name': (e) ->
    name = e.target.innerText
    $('input#card-search-input').val(name)
    ShortCardsIndex.getComponentMethods().search(name)

Template.editDeck.helpers
  beforeRemove: ->
    return (collection, id) ->
      doc = collection.findOne id
      if confirm('Really delete "' + doc.name + '"?')
        this.remove()
