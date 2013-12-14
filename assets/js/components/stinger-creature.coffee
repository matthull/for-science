Crafty.c 'Stingy',
  init: ->
    this.requires('NPC')
    this.requires('MapObject').mapObject 'Stinger'

    @mood = 'indifferent'
    @biomeWeight = 200
