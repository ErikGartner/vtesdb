Template.cards.helpers
  CardsIndex: ->
    return CardsIndex

  loadMoreAttributes: ->
    return {class: 'ui green fluid big button'}

  inputAttributes: ->
    return {value: @searchString, id: 'searchField'}
