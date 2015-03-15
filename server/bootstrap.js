Meteor.AppCache.config({onlineOnly: ['/cards/']});

Meteor.startup(function () {

  Assets.getText('version.json', function(err, data){

    var oldVer = Version.findOne({});
    if(err == null) {
      var ver = JSON.parse(data);
    } else {
      var ver = {branch:'', commit:'detached', timestamp:''};
    }

    if(!oldVer || oldVer.commit != ver.commit){

      console.log('Updating carddatabase and git version..');
      Version.remove({});
      Version.insert(ver);
      Cards.remove({});


      console.log('Reading all cards...');

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

      console.log('Done!');

    }
  });


});
