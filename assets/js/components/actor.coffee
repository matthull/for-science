Crafty.c 'Actor',
  init: ->
    this.requires 'Solid'
    @active = false

  act: ->
    this.activate()
    @movementPoints = @attributes.move
    this._act() if typeof this._act == 'function'

  deactivate: ->
    @active = false

  activate: ->
    @active = true

  acted: ->
    this.deactivate()
    Crafty.trigger 'acted'

  moved: ->
    @movementPoints--

    if @movementPoints == 0
      this.acted()
    else
      this.activate()
      this._act() if typeof this._act == 'function'

  moveTo: (destination) ->
    this.tween {x: destination.x, y: destination.y}, Game.engine.movementSpeed, => this.moved()
