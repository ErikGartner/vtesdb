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
      Cards.remove {}
      console.log 'Reading all cards...'
      cards = JSON.parse(Assets.getText('vteslib.json'))
      i = 0
      while i < cards.length
        Cards.insert
          name: cards[i]['Name']
          norm_name: cards[i]['Norm-Name']
          text: cards[i]['Card Text']
          requirement: cards[i]['Requirement']
          clan: cards[i]['Clan']
          discipline: cards[i]['Discipline']
          bloodCost: cards[i]['Blood Cost']
          poolCost: cards[i]['Pool Cost']
          set: cards[i]['Set']
          banned: cards[i]['Banned']
          type: cards[i]['Type']
          cardId: cards[i]['id']
          cardType: 'lib'
        i++
      cards = JSON.parse(Assets.getText('vtescrypt.json'))
      i = 0
      while i < cards.length
        Cards.insert
          name: cards[i]['Name']
          norm_name: cards[i]['Norm-Name']
          text: cards[i]['Card Text']
          clan: cards[i]['Clan']
          adv: cards[i]['Adv']
          capacity: cards[i]['Capacity']
          group: cards[i]['Group']
          disciplines: cards[i]['Disciplines']
          title: cards[i]['Title']
          artist: cards[i]['Artist']
          set: cards[i]['Set']
          banned: cards[i]['Banned']
          type: cards[i]['Type']
          cardId: cards[i]['id']
          cardType: 'crypt'
        i++
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
