Meteor.methods({
  setInv: function (id, count) {

    // Make sure the user is logged in before inserting a task
    var uid = Meteor.userId();
    if (!uid) {
      throw new Meteor.Error('not-authorized');
    }

    check(id, String);
    check(count, Match.Integer);
    if(count < 0){
      return;
    }

    var card = Cards.findOne({_id:id});
    if(card){
        Inventories.upsert({
          cardId: id,
          owner: uid,
        },
        {'count': count,
        cardId: id,
        cardName: card.name,
        owner: uid});
    }else{
      console.log('User tried to set inventory on invalid card: ' + id);
    }
  }
});
