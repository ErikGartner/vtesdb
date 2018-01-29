Template.cards.helpers
  CardsIndex: ->
    return CardsIndex

  loadMoreAttributes: ->
    return {class: 'ui green fluid big button'}

  inputAttributes: ->
    return {value: @searchString, id: 'card-search-input'}

Template.searchHelp.onRendered ->
  $('.ui.accordion').accordion()

Template.searchHelp.events
  'click a.searchExample': (e) ->
    s = e.target.innerText
    $('input#card-search-input').val(s)
    CardsIndex.getComponentMethods().search(s)
