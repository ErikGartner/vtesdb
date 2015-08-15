Template.decks.helpers
  decks: ->
    return Decks.find()

Template.decks.onRendered ->
  $('.ui.dropdown').dropdown()
