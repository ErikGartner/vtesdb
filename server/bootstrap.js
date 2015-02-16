Meteor.startup(function () {

  var meta = Cards.findOne({dbmetadata: 'version'});
  if(!meta || meta.version != CARD_DATABASE_VERSION){
    console.log('Cards database version incorrect; purging.');
    Cards.remove({});
  }

  if (Cards.find().count() === 0) {

    var cards = JSON.parse(Assets.getText('vteslib.json'));
    for(var i = 0; i < cards.length; i++){
      Cards.insert({name: cards[i]['Name'],
                    text: cards[i]['Card Text'],
                    requirement: cards[i]['Requirement'],
                    clan: cards[i]['Clan'],
                    discipline: cards[i]['Discipline'],
                    bloodCost: cards[i]['Blood Cost'],
                    poolCost: cards[i]['Pool Cost'],
                    set: cards[i]['Set'],
                    banned: cards[i]['Banned'],
                    type: cards[i]['Type'],
                    cardId: cards[i]['id'],
                    cardType: 'lib'});
    }

    var cards = JSON.parse(Assets.getText('vtescrypt.json'));
    for(var i = 0; i < cards.length; i++){
      Cards.insert({name: cards[i]['Name'],
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
                    cardId: cards[i]['id'],
                    cardType: 'crypt'});
    }

    Cards.insert({dbmetadata: 'version', version: CARD_DATABASE_VERSION});

  }

  // Update git version
  if (Version.find().count() > 0){
       Version.remove({});
   }
   Version.insert(JSON.parse(Assets.getText("version.json")));

});
