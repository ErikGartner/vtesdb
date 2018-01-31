parameter_regex = ///
  (?:
    \s*([^\s]*):\s?"([^"]*)"\s*     # capture field_name:"value with spaces"
    |                               # or
    \s*([^\s]*):\s?([^\s]*)\s*      # field_name:value_with_no_spaces
  )
  ///ig

parameterize_query = (searchObject) ->
  # Takes a query string and splits it into fields
  orig_query = searchObject.norm_name
  norm_name = orig_query
  new_objects = []

  while (m = parameter_regex.exec orig_query)?
    quoted_match = if m[1] then true else false
    matched_string = m[0]
    field = if quoted_match then m[1] else m[3]
    value = if quoted_match then m[2] else m[4]
    norm_name = norm_name.replace matched_string, ''
    new_objects.push {field: field, value: value}

  new_objects.push {field: 'norm_name', value: norm_name}
  return new_objects

selectorPerField = (field, searchString) ->
  # My custom implementation of handling fields and their search strings
  selector = {}
  searchString = searchString.replace(/(\W{1})/g, '\\$1')
  selector[field] = { '$regex' : ".*#{ searchString }.*", '$options' : 'i'}
  return selector

selector_function = (searchObject, options, aggregation) ->
  searchObjects = parameterize_query(searchObject)
  engine = @
  selectors = _.map searchObjects, (searchObject) ->
    return selectorPerField searchObject.field, searchObject.value
  return {$and: selectors}

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
  engine: new EasySearch.Minimongo()
