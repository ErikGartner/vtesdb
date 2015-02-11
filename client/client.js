Meteor.subscribe('cards');
Meteor.subscribe('inventories');
Meteor.subscribe('decks');
Meteor.subscribe('deckCards');
Cards.initEasySearch('name');

// Fetches inventory for a card
Template.card.helpers({
  inventoryCount: function () {
    card = Inventories.findOne({cardId: this.cardId});
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

Template.deckBar.helpers({
  allDecks: function() {
    return Decks.find({});
  },

  inDecks: function() {
    return DeckCards.find({cardId: this.cardId});
  },

  getDeckName: function() {

    var deck = Decks.findOne({_id: this.deckId});
    if(deck){
      return deck.deckName;
    }else{
      return '';
    }
  }

});

Template.searchBox.events({
  'submit .set-inv': function (event) {

    var id = event.target.id.value;
    var count = event.target.text.value;

    Meteor.call('setInv', id, count);
    $('.badge-button').popover('destroy');
    return false;

  },

  'submit .add-deck': function (event) {

    var deckName = event.target.deckName.value;
    var cardId = event.target.cardId.value;

    $('.badge-button').popover('destroy');
    Meteor.call('addDeck', deckName, cardId);
    return false;

  },

  'submit .set-deck': function (event) {

    var cardId = event.target.cardId.value;
    var deckId = event.target.deckId.value;
    var count = event.target.count.value;

    $('.badge-button').popover('destroy');
    Meteor.call('setDeck', deckId, cardId, count);
    return false;

  }
});
