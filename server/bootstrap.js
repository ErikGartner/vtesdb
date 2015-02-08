Meteor.startup(function () {

  // Empty database.
  // Cards.remove({});

  if (Cards.find().count() === 0) {

    var cards = JSON.parse(Assets.getText("vteslib.json"));
    for(var i = 0; i < cards.length; i++){
      Cards.insert({name: cards[i]["Name"],
                    text: cards[i]["Card Text"],
                    type: 'lib'});
    }

    var cards = JSON.parse(Assets.getText("vtescrypt.json"));
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

  var myid = "bjQG4ttDtEAo76y2S";

  //Inventories.remove({});
  //Load my inv for testing purpose
  if(Inventories.find().count() == 0) {

    var inventory = JSON.parse(Assets.getText("inv.json"));

    for(var key in inventory["crypt"]){
      Inventories.insert({name: key,
                          count: inventory["crypt"][key],
                          owner: myid});
    }

    for(var key in inventory["library"]){
      Inventories.insert({name: key,
                          count: inventory["library"][key],
                          owner: myid});
    }

  }

});
