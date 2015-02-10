Meteor.methods({
  setInv: function (id, count) {

    // Make sure the user is logged in before inserting a task
    var uid = Meteor.userId();
    if (!uid) {
      throw new Meteor.Error("not-authorized");
    }

    var count = parseInt(count);
    if(isNaN(count) || count < 0) {
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
