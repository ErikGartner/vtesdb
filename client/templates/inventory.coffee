@ArdbInventory = new Mongo.Collection(null)

Template.inventory.helpers
  libraryCount: ->
    return ArdbInventory.find(type: 'lib').count()

  cryptCount: ->
    return ArdbInventory.find(type: 'crypt').count()

  unmatchedCount: ->
    return ArdbInventory.find(id:-1).count()

  isMatched: ->
    return @id != -1

  ardbCards: ->
    return ArdbInventory.find()

Template.inventory.rendered = ->
  $('.ui.sticky').sticky({context: '#card-table'})

Template.inventory.events
  'change #ardb-load': (event) ->
    file = event.target.files[0]
    reader = new FileReader()

    reader.onstart = (event) ->
      console.log 'started'
      ArdbInventory.remove({})

    reader.onerror = (event) ->
      console.log 'error'
      ArdbInventory.remove({})

    reader.onprogress = (event) ->
      console.log 'Reading file...'

    reader.onload = (event) ->
      xml = $($.parseXML(event.target.result))
      date = xml.find('date')
      vampires = xml.find('vampire')
      libs = xml.find('library card')
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

        Meteor.call 'idFromName', name, adv, (err, res) ->
          if err?
            console.log console.error
          else
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

        Meteor.call 'idFromName', name, adv, (err, res) ->
          if err?
            console.log console.error
          else
            ArdbInventory.update ardbid:ardbid, {$set: {id: res}}
      return

    reader.readAsText(file)
    return false
