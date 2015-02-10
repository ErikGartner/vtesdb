Meteor.startup(function () {

  var meta = Cards.findOne({dbmetadata: 'version'});
  if(!meta || meta.version != CARD_DATABASE_VERSION){
    console.log('Cards database version incorrect; purging.');
    Cards.remove({});
  }

  if (Cards.find().count() === 0) {

    var cards = JSON.parse(Assets.getText('vteslib.json'));
    for(var i = 0; i < cards.length; i++){
      var id = Cards.insert({name: cards[i]['Name'],
                            text: cards[i]['Card Text'],
                            requirement: cards[i]['Requirement'],
                            clan: cards[i]['Clan'],
                            discipline: cards[i]['Discipline'],
                            bloodCost: cards[i]['Blood Cost'],
                            poolCost: cards[i]['Pool Cost'],
                            set: cards[i]['Set'],
                            banned: cards[i]['Banned'],
                            type: cards[i]['Type'],
                            cardType: 'lib'});

      Inventories.update({cardName: cards[i]['Name']}, {$set: {cardId: id}}, {multi: true});
    }

    var cards = JSON.parse(Assets.getText('vtescrypt.json'));
    for(var i = 0; i < cards.length; i++){
      var id = Cards.insert({name: cards[i]['Name'],
                            text: cards[i]['Card Text'],
                            clan: cards[i]['Clan'],
                            adv: cards[i]['Adv'],
                            capacity: cards[i]['Capacity'],
                            group: cards[i]['Group'],
                            disciplines: cards[i]['Disciplines'],
                            title: cards[i]['Title'],
                            artist: cards[i]['Artist'],
                            set: cards[i]['Set'],
                            banned: cards[i]['Banned'],
                            type: cards[i]['Type'],
                            cardType: 'crypt'});

      Inventories.update({cardName: cards[i]['Name']}, {$set: {cardId: id}}, {multi: true});
    }

    Cards.insert({dbmetadata: 'version', version: CARD_DATABASE_VERSION});

  }

});
