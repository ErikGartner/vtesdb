// Order in which databases are sent.
Meteor.subscribe('version');
Meteor.subscribe('decks');
Meteor.subscribe('inventories');
Meteor.subscribe('deckCards');


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

Template.footer.helpers({
  version:function(){
    return Version.findOne();
  }
})

Template.cards.helpers({

  allDecks: function() {
    return Decks.find({});
  },

  searchDecks: function(text) {
    console.log('searched for ' + text);
    return Decks.find({deckName: text});
  }

});

Template.cards.events({

  'submit .set-inv': function (event) {

    var id = event.target.id.value;
    var count = parseInt(event.target.text.value);

    Meteor.call('setInv', id, count);
    $('.badge-button').popover('destroy');
    return false;

  },

  'submit .add-deck': function (event) {

    var deckName = event.target.deckName.value;
    var cardId = event.target.cardId.value;

    $('.badge-button').popover('destroy');
    Meteor.call('addDeck', deckName, function (err, res){
      if(!err){
        Meteor.call('setDeckCard', res, cardId, 1);
      }
    });
    return false;

  },

  'submit .set-deck': function (event) {

    var cardId = event.target.cardId.value;
    var deckId = event.target.deckId.value;
    var count = parseInt(event.target.count.value);

    $('.badge-button').popover('destroy');
    Meteor.call('setDeckCard', deckId, cardId, count);
    return false;

  },

  'input #add-deck-input': function(event) {

    if(typeof(deckThread) !== 'undefined'){
      Meteor.clearTimeout(deckThread);
    }

    deckThread = Meteor.setTimeout(function() {

      $('#add-deck-results').empty();
      var val = event.target.value;
      if(val.length===0){
        return;
      }

      var decks = Decks.find({deckName: {$regex : ".*" + val.toLowerCase() + ".*"}}, {limit:5});
      decks.forEach(function(element) {
        var html = '<a class="badge badge-deck badge-item" data-deckid="' + element._id +'">' + element.deckName + '</a> ';
        $('#add-deck-results').append(html);
      });
    }, 500);
  },

  'focusout .badge-input': function(event) {
    $('.badge-button').popover('destroy');
  },

  'click .badge-item': function(event) {

    var cardId = $('[name="cardId"]').val();
    var deckId = event.target.attributes['data-deckid'].value;

    $('.badge-button').popover('destroy');
    Meteor.call('setDeckCard', deckId, cardId, 1);
    return false;

  }

});

Template.card.events({

  'click .badge-button': function(event) {
    $(event.target).popover('show');
    $('.badge-input').focus();
  }

});


Template.card.rendered = function () {

  // Activate popover for card images
  $(function () {
    $('.card-name').popover();
  });

};
