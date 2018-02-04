import { ReactiveVar } from 'meteor/reactive-var'

@simCrypt = ReactiveVar([])
@cryptSize = ReactiveVar(3)
@simLibrary = ReactiveVar([])
@handSize = ReactiveVar(7)
@ashHeap = ReactiveVar([])

buildDeck = (deckCards) ->
  list = _.map(_.values(deckCards), (card) ->
    cards = []
    for i in [0...card.deck_count]
      c = _.clone(card)
      c.deck_id = c.card_id + i
      cards.push(c)
    return cards
  )
  return _.flatten(list)

moveCard = (fromList, toList, cardId) ->
  list = fromList.get()
  card = _.find(list, (card) -> return card.deck_id == cardId)
  if card?
    list = _.without(list, card)
    fromList.set(list)
    heap = toList.get()
    heap.unshift(card)
    toList.set(heap)

Template.simulator.onRendered ->
  simCrypt.set(_.shuffle(buildDeck(@data.crypt())))
  simLibrary.set(_.shuffle(buildDeck(@data.library())))
  ashHeap.set([])
  cryptSize.set(4)
  handSize.set(7)

Template.simulator.helpers
  currentCrypt: ->
    return simCrypt.get().slice(0, cryptSize.get())

  currentLib: ->
    return simLibrary.get().slice(0, handSize.get())

  ashHeap: ->
    return ashHeap.get()

  ashSize: ->
    return ashHeap.get().length

Template.simulatorCard.events
  'click .simCard': (event) ->
    # Clicking to remove a card
    id = event.currentTarget.dataset['id']
    moveCard(simCrypt, ashHeap, id)
    moveCard(simLibrary, ashHeap, id)

Template.simulator.events
  'click .ashCard': (event) ->
    # Clicking to remove a card
    id = event.currentTarget.dataset['id']
    card = _.find(ashHeap.get(), (card) -> return card.deck_id == id)
    console.log(card)
    if card.type == 'Vampire' or card.type == 'Imbued'
      moveCard(ashHeap, simCrypt, id)
    else
      moveCard(ashHeap, simLibrary, id)

  'click #shuffleButton': (event) ->
    simCrypt.set(_.shuffle(buildDeck(@crypt())))
    simLibrary.set(_.shuffle(buildDeck(@library())))
    ashHeap.set([])
    cryptSize.set(4)
    handSize.set(7)

  'click #addHandSize': (event) ->
    handSize.set(handSize.get() + 1)

  'click #addCryptSize': (event) ->
    cryptSize.set(cryptSize.get() + 1)
