// Returns all library and crypt cards.
Meteor.publish("cards", function () {
  return Cards.find();
});

// Returns the inventory belonging to the user.
Meteor.publish("inventories", function () {
  return Inventories.find({owner: this.userId});
});
