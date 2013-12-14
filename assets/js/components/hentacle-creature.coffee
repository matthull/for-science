Crafty.c 'Hentacle',
  init: ->
    this.requires('NPC')
    this.requires('MapObject').mapObject 'HentacleSprite'

    @mood = 'indifferent'
    @biomeWeight = 200
