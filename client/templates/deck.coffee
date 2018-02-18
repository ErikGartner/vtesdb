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

  countCards: (cards) ->
    counts = _.map(cards, (card) -> return card.deck_count)
    return _.reduce(counts, (m, n) -> return m + n)

  parentName: ->
    p = Decks.findOne @parent
    return p.name

Template.deck.events

  'click a.card-name': (e) ->
    name = e.target.innerText
    $('input#card-search-input').val(name)
    ShortCardsIndex.getComponentMethods().search(name)

  'click #forkButton': (e) ->
    new_id = Meteor.call 'forkDeck', @_id, (err, res) ->
      if err?
        console.log err
        return
      Router.go 'decks.view', {_id: res}

Template.editDeck.helpers
  beforeRemove: ->
    return (collection, id) ->
      doc = collection.findOne id
      if confirm('Really delete "' + doc.name + '"?')
        this.remove()
