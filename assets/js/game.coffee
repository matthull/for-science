MOVEMENT_SPEED = 10
TILE_SIZE= 32

MAP_WIDTH = 15
MAP_HEIGHT = MAP_WIDTH

class Engine
  constructor: ->
    this.locks = 0

  unlock: ->
    this.locks-- if this.locked()

  lock: ->
    this.locks++

  locked: ->
    this.locks > 0

Crafty.scene 'Main', ->
  Crafty.e('2D, DOM, TiledMapBuilder').setMapDataSource(MAP_SOURCE)
    .createView 0, 0, MAP_WIDTH, MAP_HEIGHT, (map) ->
      window.map = map
      map.getEntitiesInLayer('Obstacles').forEach (o) ->
        o.addComponent('Collision').collision()

  window.pc = Crafty.e('2D, DOM, Fourway, Sprite, PC2, PC, Collision, Tween')
    .attr({x: TILE_SIZE * (Math.floor MAP_WIDTH / 2), y: TILE_SIZE * (Math.floor MAP_HEIGHT / 2), z: 100})
    .collision()
    #.fourway(TILE_SIZE)
    .bind('KeyDown', (e) ->
      return if Game.engine.locked()
      Game.engine.lock()
      destination = this.pos()
      if (e.key == Crafty.keys['H']) then destination._x = this.x - TILE_SIZE
      if (e.key == Crafty.keys['L']) then destination._x = this.x + TILE_SIZE
      if (e.key == Crafty.keys['J']) then destination._y = this.y + TILE_SIZE
      if (e.key == Crafty.keys['K']) then destination._y = this.y - TILE_SIZE

      return Game.engine.unlock() if _.some(map.getEntitiesInLayer('Obstacles'), (o) -> o.isAt(destination._x, destination._y))

      this.tween {x: destination._x, y: destination._y}, MOVEMENT_SPEED
    )
    .bind('TweenEnd', -> Game.engine.unlock())

window.Game =
  start: ->
    Crafty.init 480, 480
    Crafty.background '#000'
    #Crafty.load ["images/mario-jump.png"], ->
    #Crafty.sprite("images/mario-jump.png", {PC: [0,0,32,32]})
    Crafty.sprite("images/mario-standing.png", {PC2: [0,0,32,32]})
    Game.engine = new Engine
    Crafty.scene 'Main'
