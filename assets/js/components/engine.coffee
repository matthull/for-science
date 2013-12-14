Crafty.c 'Engine',
  init: ->
    @ended = false

    @movementSpeed = 300

    @tileSize = 64
    @mapWidth = 50
    @mapHeight = 50
    @viewportWidth = 12 * @tileSize - (@tileSize/2) - 40
    @viewportHeight = 10 * @tileSize - (@tileSize/2) - 40

    @queue = Crafty.e 'ActorQueue'
    Crafty.bind 'acted', @callNextActor

  callNextActor: ->
    actor = Game.engine.queue.advance()
    actor.act()
