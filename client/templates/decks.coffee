Template.decks.helpers
  decks: ->
    return Decks.find()

  selectedDeck: ->
    return Decks.findOne(_id:Session.get('selected-deck'))

Template.decks.onRendered ->
  $('#deck-dropdown').dropdown(
    allowAdditions: false
    match: 'text'
    forceSelection: false
    onChange: (value, text, $choice) ->
      Session.set('selected-deck', value)
  )

Template.decks.events
  'click #add-deck': (event) ->
    name = $('#deck-dropdown').dropbox('get text')
    Meteor.call 'addDeck', name, (err, res) ->
      if res?
        $('#deck-dropdown').dropdown('set selected', res)
      return
    return
