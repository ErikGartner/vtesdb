Meteor.methods({
  setInv: function (id, count) {

    // Make sure the user is logged in before inserting a task
    if (! Meteor.userId()) {
      throw new Meteor.Error("not-authorized");
    }

    var card = Cards.findOne({_id:id});
    if(card){
        Inventories.upsert({
          _id: id,
          owner: Meteor.userId(),
        },{'count': count, name: card.name, owner: Meteor.userId()});
    }else{
      console.log('User tried to set inventory on invalid card: ' + id);
    }
  }
});
