Meteor.methods({
  setInv: function (id, count) {

    // Make sure the user is logged in before inserting a task
    if (! Meteor.userId()) {
      throw new Meteor.Error("not-authorized");
    }

    Inventories.upsert({
      name: id,
      owner: Meteor.userId(),
    },{'count': count, name: id, owner: Meteor.userId()});
  }
});
