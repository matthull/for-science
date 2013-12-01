Crafty.c 'Engine',
  init: ->
    @queue = Crafty.e 'ActorQueue'
    Crafty.bind 'acted', @callNextActor

  ended: false

  movementSpeed: 300

  tileSize: 64
  mapWidth: 50
  mapHeight: 50
  viewportWidth: 10 * this.tileSize
  viewportHeight: 10 * this.tileSize

  callNextActor: ->
    actor = Game.engine.queue.advance()
    actor.act()
