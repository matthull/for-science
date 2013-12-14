Crafty.c 'Hoppy',
  init: ->
    this.requires('NPC')
    this.requires('MapObject').mapObject 'HoppySprite'

    @mood = 'indifferent'
    @biomeWeight = 200
