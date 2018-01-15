Meteor.startup ->
  Assets.getText 'version.json', (err, data) ->
    oldVer = Version.findOne({})
    if err == null
      ver = JSON.parse(data)
    else
      ver =
        branch: ''
        commit: 'detached'
        timestamp: ''

    if !oldVer or oldVer.commit != ver.commit or Cards.find().count() == 0
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

    return
  return
