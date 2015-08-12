Template.cards.events
  'submit .set-inv': (event) ->
    id = event.target.id.value
    count = parseInt(event.target.text.value)
    Meteor.call 'setInv', id, count
    $('.badge-button').popover 'destroy'
    return false

  'submit .add-deck': (event) ->
    deckName = event.target.deckName.value
    cardId = event.target.cardId.value
    $('.badge-button').popover 'destroy'
    Meteor.call 'addDeck', deckName, (err, res) ->
      if !err
        Meteor.call 'setDeckCard', res, cardId, 1
      return
    return false

  'submit .set-deck': (event) ->
    cardId = event.target.cardId.value
    deckId = event.target.deckId.value
    count = parseInt(event.target.count.value)
    $('.badge-button').popover 'destroy'
    Meteor.call 'setDeckCard', deckId, cardId, count
    return false

  'input #add-deck-input': (event) ->
    if typeof deckThread != 'undefined'
      Meteor.clearTimeout deckThread
    deckThread = Meteor.setTimeout((->
      $('#add-deck-results').empty()
      val = event.target.value
      if val.length == 0
        return
      decks = Decks.find({ deckName: $regex: '.*' + val.toLowerCase() + '.*' }, limit: 5)
      decks.forEach (element) ->
        html = '<a class="badge badge-deck badge-item" data-deckid="' + element._id + '">' + element.deckName + '</a> '
        $('#add-deck-results').append html
        return
      return
    ), 500)
    return

  'focusout .badge-input': (event) ->
    $('.badge-button').popover 'destroy'
    return

  'click .badge-item': (event) ->
    cardId = $('[name="cardId"]').val()
    deckId = event.target.attributes['data-deckid'].value
    $('.badge-button').popover 'destroy'
    Meteor.call 'setDeckCard', deckId, cardId, 1
    return false

Template.card.events 'click .badge-button': (event) ->
  $(event.target).popover 'show'
  $('.badge-input').focus()
  return
