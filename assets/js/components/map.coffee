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

  inbounds: (x, y) ->
    x <= this.w && y <= this.h && x >= 0 && y >= 0
