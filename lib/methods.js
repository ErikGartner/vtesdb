Meteor.methods({
  setInv: function (id, count) {

      var uid = Meteor.userId();
      if (!uid) {
        throw new Meteor.Error('not-authorized');
      }

      var count = parseInt(count);
      if(isNaN(count) || count < 0) {
        return;
      }

      var card = Cards.findOne({cardId: id});
      if(card){
        if(count > 0){
          Inventories.upsert({cardId: id, owner: uid}, {'count': count,
                              cardId: id, cardName: card.name, owner: uid});
        }else{
          Inventories.remove({cardId: id});
        }
      }else{
        console.log('User tried to set inventory on invalid card: ' + id);
      }
  },

  addDeck: function(deckName, cardId) {

    var uid = Meteor.userId();
    if (!uid) {
      throw new Meteor.Error('not-authorized');
    }

    var card = Cards.findOne({'cardId': cardId});
    if(card){
        var deckId = Decks.insert({'deckName': deckName,
                                  owner: uid});
        DeckCards.insert({'deckId': deckId,
                          'cardId': cardId,
                          deckCount: 1,
                          owner: uid});
    }else{
      console.log('Invalid card id while creading a deck: ' + id);
    }
  },

  setDeck: function(deckId, cardId, count) {

    var uid = Meteor.userId();
    if (!uid) {
      throw new Meteor.Error('not-authorized');
    }

    var count = parseInt(count);
    if(isNaN(count) || count < 0) {
      return;
    }

    if(count > 0){
      DeckCards.update({'deckId': deckId, 'cardId': cardId}, {$set: {deckCount: count}});
    }else{
      DeckCards.remove({'deckId': deckId, 'cardId': cardId});
    }

  }

});
