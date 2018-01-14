parameter_regex = ///
  (?:
    \s*([^\s]*):\s?"([^"]*)"\s*     # capture field_name:"value with spaces"
    |                               # or
    \s*([^\s]*):\s?([^\s]*)\s*      # field_name:value_with_no_spaces
  )
  ///ig

parameterize_query = (searchObject) ->
  orig_query = searchObject.norm_name
  norm_name = orig_query
  new_object = {}

  while (m = parameter_regex.exec orig_query)?
    quoted_match = if m[1] then true else false
    matched_string = m[0]
    field = if quoted_match then m[1] else m[3]
    value = if quoted_match then m[2] else m[4]
    norm_name = norm_name.replace matched_string, ''
    new_object[field] = value

  new_object.norm_name = norm_name
  return new_object


@CardsIndex = new EasySearch.Index
  name: 'card_index'
  collection: Cards
  fields: ['norm_name']
  defaultSearchOptions:
    limit: 8
  engine: new EasySearch.MongoDB
    selector: (searchObject, options, aggregation) ->
      searchObject = parameterize_query(searchObject)
      selector = @defaultConfiguration()
        .selector(searchObject, options, '$and')
      return selector

@ShortCardsIndex = new EasySearch.Index
  name: 'short_card_index'
  collection: Cards
  fields: ['norm_name']
  defaultSearchOptions:
    limit: 3
  engine: new EasySearch.MongoDB
    selector: (searchObject, options, aggregation) ->
      searchObject = parameterize_query(searchObject)
      selector = @defaultConfiguration()
        .selector(searchObject, options, '$and')
      return selector

@DeckIndex = new EasySearch.Index
  collection: Decks
  fields: ['name']
  engine: new EasySearch.Minimongo()
