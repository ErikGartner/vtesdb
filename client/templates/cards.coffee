Template.cards.onRendered ->
  console.log 'detected'
  commands =
    'show': () ->
      $('.search-field').text('hej')
      return
  annyang.init(commands, true)
  return

Template.cards.events
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

  'click #voice-button': (event) ->
    console.log 'hello'
    if $(event.target).hasClass('unmute')
      annyang.start()
      annyang.debug(true)
    return

Template.cards.helpers
  CardsIndex: ->
    return CardsIndex

  loadMoreAttributes: ->
    return {class: "ui green fluid button"}
