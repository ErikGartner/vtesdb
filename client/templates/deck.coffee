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

  deckCardStatus: (card_id) ->

    card = Inventories.findOne(card_id: card_id)
    inventory = if card? then card.count else 0

    deck_id =  Router.current().data()._id

    # Find active decks that use the card
    deck = Decks.findOne deck_id

    if deck?

      # Total the amount used
      used = deck.cards[card_id]

      missing = if used > inventory then used - inventory else false
      return {card_id: card_id, inv: inventory, used: used, missing: missing}

    else
      return {card_id: card_id, inv: inventory, used: 0, missing: false}

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
