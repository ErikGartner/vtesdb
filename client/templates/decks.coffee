Template.decks.helpers
  decks: ->
    return Decks.find()

Template.decks.onRender ->
  $('.ui.dropdown').dropdown()
