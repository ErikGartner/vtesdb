Meteor.startup(function () {

  // Empty database.
  // Cards.remove({});

  if (Cards.find().count() === 0) {

    // Read cardlist from csv database and load into mongo.

    var cards = JSON.parse(Assets.getText('vteslib.json'));
    for(var i = 0; i < cards.length; i++){
      Cards.insert({name: cards[i]["Name"],
                    text: cards[i]["Card Text"],
                    type: 'lib'});
    }

    var cards = JSON.parse(Assets.getText('vtescrypt.json'));
    for(var i = 0; i < cards.length; i++){
      Cards.insert({name: cards[i]["Name"],
                    text: cards[i]["Card Text"],
                    clan: cards[i]["Clan"],
                    adv: cards[i]["Adv"],
                    capacity: cards[i]["Capacity"],
                    group: cards[i]["Group"],
                    disciplines: cards[i]["Disciplines"],
                    type: 'vamp'});
    }

  }

});
