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

  inbounds: (location) ->
    location.x <= this.w && location.y <= this.h && location.x >= 0 && location.y >= 0

  distance: (distance) ->
    if distance.pixels and distance.tiles
        return distance
    else if distance.pixels
      distance.tiles = distance.pixels / Game.engine.tileSize
    else if distance.tiles
      distance.pixels = distance.tiles * Game.engine.tileSize
    else
      throw 'You need to specify either pixels or tiles to get distance!'

    distance

  relativeLocation: (start, direction, distance) ->
    distance = Game.map.distance distance

    destination = start
    if direction == 'left' then destination.x -= distance.pixels
    if direction == 'up' then destination.y -= distance.pixels
    if direction == 'right' then destination.x += distance.pixels
    if direction == 'down' then destination.y += distance.pixels

    destination
