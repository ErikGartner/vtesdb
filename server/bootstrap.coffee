Meteor.startup ->
  if Cards.find().count() == 0
    console.log 'Reading all cards...'
    Cards.remove {}
    cards = JSON.parse(Assets.getText('cards.json'))
    _.each cards, (card) ->
      Cards.insert card
    console.log 'Done!'

    console.log 'Reading rulings'
    rulings = JSON.parse(Assets.getText('cardrulings.json'))
    for rule in rulings
      Cards.update {card_id: rule['id']}, {$set: {rulings: rule['rulings']}}
    console.log 'Done!'

    # Decks.remove {owner: 'TWD'}
    # console.log 'Reading TWDs'
    # decks = JSON.parse(Assets.getText('twds.json'))
    # for deck in decks
    #   Decks.insert {
    #     name: deck['name']
    #     cards: deck['cards']
    #     owner: 'TWD'
    #     description: deck['description']
    #     public: true
    #     active: false
    #   }, {bypassCollection2: true}
    # console.log 'Done!'
