Meteor.subscribe('cards');
Meteor.subscribe('inventories');
Cards.initEasySearch('name');

// Fetches inventory for a card
Template.card.helpers({
  inventoryCount: function () {
    card = Inventories.findOne({cardId: this._id});
    if(card){
      return card.count;
    }else{
      return 0;
    }
  },
  isCryptCard: function() {
    return this.cardType == 'crypt';
  }
});

Template.searchBox.events({
  'submit .set-inv': function (event) {

    var id = event.target.id.value;
    var count = event.target.text.value;

    Meteor.call('setInv', id, count);
    $('.badge-inv').popover('destroy');
    return false;

  },

  'click .badge-inv': function(event) {
    $(event.target).popover('show');
    $('.badge-input').focus();
  },

  'focusout .badge-input': function(event) {
    $('.badge-inv').popover('hide');
  }

});
