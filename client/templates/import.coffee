@ArdbInventory = new Mongo.Collection(null)

Template.import.helpers
  libraryCount: ->
    return ArdbInventory.find(type: 'lib').count()

  cryptCount: ->
    return ArdbInventory.find(type: 'crypt').count()

  importedCount: ->
    return ArdbInventory.find().count() - ArdbInventory.find(id:-1).count()

  isMatched: ->
    return @id != -1 and @id != -2

  isLoading: ->
    return @id == -1

  ardbCards: ->
    return ArdbInventory.find()

Template.import.onDestroyed ->
  ArdbInventory.remove({})

Template.import.events
  'change #ardb-load': (event) ->
    file = event.target.files[0]
    reader = new FileReader()

    reader.onload = (event) ->
      console.log 'Done reading file. Parsing..'
      ArdbInventory.remove({})
      xml = $($.parseXML(event.target.result))
      date = xml.find('date')
      vampires = xml.find('vampire')
      libs = xml.find('library card')
      ArdbInventory.remove({})
      vampires.each (index, element) ->
        name = $(element).find('name').text()
        adv = $(element).find('adv').text()
        have = parseInt($(element).attr('have'))
        need = parseInt($(element).attr('need'))
        want = parseInt($(element).attr('want'))
        ardbid = $(element).attr('databaseID')
        id = -1
        ArdbInventory.upsert ardbid:ardbid,
          $set: {name: name, adv: adv, id: id, type: 'crypt'}
          $inc: {have: have, need: need, want: want}

        Meteor.call 'importCardByName', name, adv, have, (err, res) ->
          if err?
            console.log console.error
          else
            res = -2 if res == -1
            ArdbInventory.update ardbid:ardbid, {$set: {id: res}}

      libs.each (index, element) ->
        name = $(element).find('name').text()
        adv = ''
        have = parseInt($(element).attr('have'))
        need = parseInt($(element).attr('need'))
        want = parseInt($(element).attr('want'))
        ardbid = $(element).attr('databaseID')
        id = -1
        ArdbInventory.upsert ardbid:ardbid,
          $set: {name: name, adv: adv, id: id, type: 'lib'}
          $inc: {have: have, need: need, want: want}

        Meteor.call 'importCardByName', name, adv, have, (err, res) ->
          if err?
            console.log console.error
          else
            res = -2 if res == -1
            ArdbInventory.update ardbid:ardbid, {$set: {id: res}}
      return

    $('#ardb-load-button').addClass 'disabled'
    reader.readAsText(file)
    $('#ardb-load-button').removeClass 'disabled'
    return false
