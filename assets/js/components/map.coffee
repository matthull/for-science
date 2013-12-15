Crafty.c 'Map',
  init: ->
    this.requires '2D, DOM, TiledMapBuilder'

  map: (source) ->
    this.setMapDataSource source
    this.createWorld()
    rightMost = _.max this.getLayers().Ground, (t) -> t.x
    this.w = rightMost.x + rightMost.w
    bottomMost = _.max this.getLayers().Ground, (t) -> t.y
    this.h = bottomMost.y + bottomMost.h

    this

  width: ->
    Game.engine.mapWidth

  height: ->
    Game.engine.mapHeight

  obstacles: ->
    this.getLayers().Obstacles

  inbounds: (location) ->
    location.x <= this.width() && location.y <= this.height() && location.x >= 0 && location.y >= 0

  distanceBetween: (start, end) ->
    x: Math.abs(start.x - end.x)
    y: Math.abs(start.y - end.y)

  totalDistanceBetween: (start, end) ->
    dist = this.distanceBetween(start, end)
    dist.x + dist.y

  tilesToPixels: (coord) ->
    coord * Game.engine.tileSize

  pixelsToTiles: (coord) ->
    coord / Game.engine.tileSize

  blocked: (location) ->
    _.some Crafty('Solid'), (e) -> Crafty(e).isAt Game.map.tilesToPixels(location.x)+1, Game.map.tilesToPixels(location.y)+1 or
      not Game.map.inbounds location

  relativeLocation: (start, direction, distance) ->
    destination = x: start.x, y: start.y
    if direction == 'left' then destination.x -= distance
    if direction == 'up' then destination.y -= distance
    if direction == 'right' then destination.x += distance
    if direction == 'down' then destination.y += distance

    destination

  tilesSurrounding: (loc) ->
    ['up', 'down', 'left', 'right'].map (dir) => this.relativeLocation loc, dir, 1

  grid: ->
    grid = new PF.Grid Game.engine.mapWidth, Game.engine.mapHeight

    Game.map.obstacles().forEach (t) ->
      grid.setWalkableAt(Game.map.pixelsToTiles(t.x), Game.map.pixelsToTiles(t.y), false) if t.x

    _.each Crafty('Solid'), (id) =>
      e = Crafty(id)
      grid.setWalkableAt(Game.map.pixelsToTiles(e.x), Game.map.pixelsToTiles(e.y), false)

    grid
