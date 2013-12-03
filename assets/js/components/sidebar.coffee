Crafty.c 'Sidebar',
  init: ->
    this.requires '2D, DOM, Text'
    @x = Game.engine.viewportWidth + 16
    @y = Game.engine.tileSize
    @w = 200
    @h = 400
    this.text('Header')

    @attrHeader = Crafty.e('2D, DOM, Text').text('test 123').attr({x: 1200, y: @y})
