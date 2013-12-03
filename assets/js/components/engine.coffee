Crafty.c 'Engine',
  init: ->
    @ended = false

    @movementSpeed = 300

    @tileSize = 64
    @mapWidth = 50
    @mapHeight = 50
    @viewportWidth = 12 * @tileSize
    @viewportHeight = 10 * @tileSize

    @queue = Crafty.e 'ActorQueue'
    Crafty.bind 'acted', @callNextActor

  callNextActor: ->
    actor = Game.engine.queue.advance()
    actor.act()
