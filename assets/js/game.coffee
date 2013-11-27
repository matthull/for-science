MOVEMENT_SPEED = 300
TILE_SIZE= 32

MAP_WIDTH = 15
MAP_HEIGHT = MAP_WIDTH

window.Game =
  ended: false
  nextActorId: 1

class Game.ActorQueue
  constructor: ->
    @actors = []
    @index = 0

  append: (actor) ->
    @actors.push actor

  remove: (actor) ->
    @actors = _.reject @actors, (a) -> a.actorId == actor.actorId

  current: ->
    @actors[@index]

  advance: ->
    if @index == @actors.length - 1 then @index = 0 else @index++
    @current()

class Game.Engine
  constructor: ->
    Game.pc = new Game.PC('PC')
    @queue = new Game.ActorQueue()
    Crafty.bind 'acted', @callNextActor

  callNextActor: =>
    actor = @queue.advance()
    #window.setTimeout actor.act, 500
    actor.act()

Game.start = ->
    Crafty.init MAP_HEIGHT * TILE_SIZE, MAP_WIDTH * TILE_SIZE
    Crafty.background '#000'
    Crafty.viewport.clampToEntities = false
    #Crafty.load ["images/mario-jump.png"], ->
    Crafty.sprite("images/mario-jump.png", {Monster1: [0,0,32,32]})
    Crafty.sprite("images/mario-standing.png", {PC: [0,0,32,32]})
    Game.engine = new Game.Engine
    Crafty.scene 'Main'

class Game.MapObject
  constructor: (spriteName) ->
    @entity = Crafty.e '2D, DOM, Sprite'
    @entity.requires spriteName

class Game.Actor extends Game.MapObject
  constructor: (@name) ->
    super(@name)
    @entity.requires 'Solid'
    @actorId = Game.nextActorId++
    @active = false

class Game.PC extends Game.Actor
  constructor: (spriteName) ->
    super(spriteName)

    @entity.requires 'Tween'
    @entity.bind 'KeyDown', (e) =>
      return unless @active
      @deactivate()
      destination = { x: @entity.x, y: @entity.y }
      if (e.key == Crafty.keys['H']) then destination.x = @entity.x - TILE_SIZE
      if (e.key == Crafty.keys['L']) then destination.x = @entity.x + TILE_SIZE
      if (e.key == Crafty.keys['J']) then destination.y = @entity.y + TILE_SIZE
      if (e.key == Crafty.keys['K']) then destination.y = @entity.y - TILE_SIZE

      if (_.some Crafty('Solid'), (e) -> Crafty(e).isAt destination.x+1, destination.y+1)
        @act()
        return console.log 'Blocked by obstacle'

      unless (Game.map.inbounds(destination.x, destination.y))
        @act()
        return console.log 'Blocked by edge of map'

      @entity.tween {x: destination.x, y: destination.y}, MOVEMENT_SPEED, -> Crafty.trigger 'acted'

  act: =>
    @active = true

  deactivate: ->
    @active = false

class Game.NPC extends Game.Actor
  constructor: (spriteName) ->
    super(spriteName)
    @entity.requires 'Tween'

  act: =>
    directions = [
      {vertical: 1, horizontal: 0},
      {vertical: -1, horizontal: 0},
      {vertical: 0, horizontal: -1},
      {vertical: 0, horizontal: 1}
    ]

    availableDirections = _.filter directions, (direction) =>
      not _.some Crafty('Solid'), (e) =>
        Crafty(e).isAt @entity.x + (direction.horizontal * TILE_SIZE) + 1, @entity.y + (direction.vertical * TILE_SIZE) + 1

    availableDirections = _.filter availableDirections, (direction) =>
      Game.map.inbounds @entity.x + (direction.horizontal * TILE_SIZE) + 1, @entity.y + (direction.vertical * TILE_SIZE) + 1

    return @acted() if availableDirections.length == 0
    chosenDirection = _.sample availableDirections

    console.log 'going to ', chosenDirection
    destination = {}
    destination.x = @entity.x + (chosenDirection.horizontal * TILE_SIZE)
    destination.y = @entity.y + (chosenDirection.vertical * TILE_SIZE)

    @entity.tween {x: destination.x, y: destination.y}, MOVEMENT_SPEED, => @acted()

  acted: ->
    Crafty.trigger 'acted'

class Game.Map
  constructor: (source) ->
    @tiledMap = Crafty.e '2D, DOM, TiledMapBuilder'
    @tiledMap.setMapDataSource source
    @tiledMap.createWorld()
    rightMost = _.max @tiledMap.getLayers().Ground, (t) -> t.x
    @tiledMap.w = rightMost.x + rightMost.w
    bottomMost = _.max @tiledMap.getLayers().Ground, (t) -> t.y
    @tiledMap.h = bottomMost.y + bottomMost.h

  height: ->
    @tiledMap.h

  width: ->
    @tiledMap.w

  inbounds: (x, y) =>
    x <= this.width() && y <= this.height() && x >= 0 && y >= 0

Crafty.scene 'Main', ->
  Game.map = new Game.Map MAP_SOURCE
  Game.map.tiledMap.getEntitiesInLayer('Obstacles').forEach (o) ->
    o.addComponent('Solid')

  Game.pc = new Game.PC('PC')
  Game.pc.entity.attr({x: TILE_SIZE * (Math.floor MAP_WIDTH / 2), y: TILE_SIZE * (Math.floor MAP_HEIGHT / 2), z: 100})
  Game.engine.queue.append Game.pc

  monster = new Game.NPC('Monster1')
  monster.entity.attr({x: TILE_SIZE * (Math.floor MAP_WIDTH / 4), y: TILE_SIZE * (Math.floor MAP_HEIGHT / 4), z: 90})
  Game.engine.queue.append monster

  Game.pc.act()

  Crafty.viewport.follow Crafty('PC'), 0, 0
