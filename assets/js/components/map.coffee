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

  inbounds: (location) ->
    location.x <= this.width() && location.y <= this.height() && location.x >= 0 && location.y >= 0

  #distance: (distance) -> if distance.pixels and distance.tiles
        #return distance
    #else if distance.pixels
      #distance.tiles = distance.pixels / Game.engine.tileSize
    #else if distance.tiles
      #distance.pixels = distance.tiles * Game.engine.tileSize
    #else
      #throw 'You need to specify either pixels or tiles to get distance!'

    #distance

  distanceBetween: (start, end) ->
    x: start.x - end.x
    y: start.y - end.y

  tilesToPixels: (coord) ->
    coord * Game.engine.tileSize

  pixelsToTiles: (coord) ->
    coord / Game.engine.tileSize

  blocked: (location) ->
    _.some Crafty('Solid'), (e) -> Crafty(e).isAt Game.map.tilesToPixels(location.x)+1, Game.map.tilesToPixels(location.y)+1 and
      not Game.map.inbounds location

  relativeLocation: (start, direction, distance) ->
    destination = start
    if direction == 'left' then destination.x -= distance
    if direction == 'up' then destination.y -= distance
    if direction == 'right' then destination.x += distance
    if direction == 'down' then destination.y += distance

    destination

  grid: ->
    grid = new PF.Grid Game.engine.mapWidth, Game.engine.mapHeight

    this.getLayers().Obstacles.forEach (t) ->
      grid.setWalkableAt(pixelsToTiles(t.x), pixelsToTiles(t.y), false) if t.x

    _.each Crafty('Solid'), (id) ->
      grid.setWalkableAt(pixelsToTiles(t.x), pixelsToTiles(t.y), false)

    grid
