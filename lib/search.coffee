@CardsIndex = new EasySearch.Index
  name: 'card_index'
  collection: Cards
  fields: ['norm_name']
  defaultSearchOptions:
    limit: 8
  engine: new EasySearch.MongoDB
    selector: (searchObject, options, aggregation) ->
      selector = @defaultConfiguration()
        .selector(searchObject, options, aggregation)
      return selector

@ShortCardsIndex = new EasySearch.Index
  collection: Cards
  fields: ['norm_name']
  engine: new EasySearch.MongoDB()
  name: 'short_card_index'
  defaultSearchOptions:
    limit: 3

@DeckIndex = new EasySearch.Index
  collection: Decks
  fields: ['name']
  engine: new EasySearch.Minimongo()
