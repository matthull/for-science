Crafty.c 'Actor',
  init: ->
    this.requires 'Solid'
    @active = false

  act: ->
    @active = true
    this._act() if typeof this._act == 'function'

  deactivate: ->
    @active = false

  acted: ->
    Crafty.trigger 'acted'
