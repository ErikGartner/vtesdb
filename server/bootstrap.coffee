Meteor.startup ->
  if Cards.find().count() == 0
    console.log 'Updating card database and git version..'
    Version.remove {}
    Version.insert ver

    console.log 'Reading all cards...'
    Cards.remove {}
    cards = JSON.parse(Assets.getText('cards.json'))
    _.each cards, (card) ->
      Cards.insert card
    console.log 'Done!'

    Rulings.remove {}
    console.log 'Reading rulings'
    rulings = JSON.parse(Assets.getText('vtescardrulings.json'))
    for rule in rulings
      Rulings.insert
        name: rule['name']
        id: rule['id']
        rulings: rule['rulings']
    console.log 'Done!'
