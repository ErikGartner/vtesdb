import EasyQuery from 'easy-query-dsl'

selector_function = (searchObject, options, aggregation) ->
  eq = new EasyQuery({
    default: {
      field: 'norm_name',
      type: 'string',
      opts: {
        caseSensitive: false,
        fuzzy: true,
      }
    },
    keys: [
      {
        field: 'artist',
        alias: ['artist'],
        type: 'string',
        opts: {
          caseSensitive: false,
          fuzzy: true,
        }
      },
      {
        field: 'blood',
        alias: ['blood', 'b'],
        type: 'number',
        opts: {}
      },
      {
        field: 'capacity',
        alias: ['capacity', 'cap'],
        type: 'number',
        opts: {}
      },
      {
        field: 'clan',
        alias: ['clan', 'c'],
        type: 'string',
        opts: {
          caseSensitive: false,
          fuzzy: true,
        }
      },
      {
        field: 'disciplines',
        alias: ['discipline', 'd'],
        type: 'string',
        opts: {
          caseSensitive: true,
          fuzzy: true,
        }
      },
      {
        field: 'pool',
        alias: ['pool', 'p'],
        type: 'number',
        opts: {}
      },
      {
        field: 'rarity',
        alias: ['rarity'],
        type: 'string',
        opts: {
          caseSensitive: false,
          fuzzy: true,
        }
      },
      {
        field: 'text',
        alias: ['text'],
        type: 'string',
        opts: {
          caseSensitive: false,
          fuzzy: true,
        }
      },
      {
        field: 'type',
        alias: ['type', 't'],
        type: 'string',
        opts: {
          caseSensitive: false,
          fuzzy: true,
        }
      },
    ]
  })
  return eq.parse(searchObject['norm_name'])

@CardsIndex = new EasySearch.Index
  name: 'card_index'
  collection: Cards
  fields: ['norm_name']
  defaultSearchOptions:
    limit: 8
  engine: new EasySearch.MongoDB
    selector: selector_function

@ShortCardsIndex = new EasySearch.Index
  name: 'short_card_index'
  collection: Cards
  fields: ['norm_name']
  defaultSearchOptions:
    limit: 3
  engine: new EasySearch.MongoDB
    selector: selector_function

@DeckIndex = new EasySearch.Index
  collection: Decks
  fields: ['name', 'description']
  engine: new EasySearch.MongoDB
    selector: (searchObject, options, aggregation) ->
      # Only return public decks or own decks
      selector = @defaultConfiguration().selector searchObject, options, aggregation
      return {$and: [{$or: [{public: true}, {owner: Meteor.userId()}]}, selector]}
