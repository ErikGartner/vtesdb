Meteor.startup ->

  all_inv = Inventories.find({cards: {$exists: false}}).fetch()

  if all_inv.length == 0
    console.log "No invetory to upgrade"
    return

  all_ids = _.map all_inv, (i) -> return i._id

  all_inv = _.groupBy all_inv, (c) -> return c.owner
  _.each all_inv, (val, key) ->
    cards = {}
    for v in val
      old_val = if cards[v.card_id]? then cards[v.card_id] else 0
      cards[v.card_id] = Math.max(old_val, v.count)
    Inventories.insert {owner: key, cards: cards}

  Inventories.remove _id: $in: all_ids
