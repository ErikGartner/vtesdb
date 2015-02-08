Meteor.subscribe("cards");
Meteor.subscribe("inventories");
Cards.initEasySearch("name");

// Fetches inventory for a card
Template.card.helpers({
  inventoryCount: function () {
    card = Inventories.findOne({name: this.name});
    if(card){
      return card.count;
    }else{
      return 0;
    }
  }
});
