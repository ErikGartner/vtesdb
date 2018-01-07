Template.deckControl.helpers
  decks: ->
    return Decks.find()

Template.deckControl.onRendered ->
  $('.deck-button').popup(popup: '.deck.popup', on: 'click')
  $('.ui.dropdown').dropdown()

Template.deckControl.events
  'submit .deck-form': (event) ->
    console.log 'hej'
    id = event.target.id.value
    count = parseInt(event.target.count.value)
    deck = event.target.deck.value
    Meteor.call 'setDeckCard', id, deck, count
    $('.deck-button').popup 'hide all'
    return false

  'click .deck-button': (event) ->
    $('.badge-input').focus()
