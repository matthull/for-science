Crafty.c 'Actor',
  init: ->
    this.requires 'Solid'
    @active = false

  act: ->
    this.activate()
    @attributes.set 'move.current', @attributes.get('move.max')

    _.each @abilities, (a) -> a.turnsUntilNextUse-- if a.turnsUntilNextUse > 0

    this._act() if typeof this._act == 'function'

  deactivate: ->
    @active = false

  activate: ->
    @active = true

  acted: ->
    this.deactivate()
    Crafty.trigger 'acted'

  moved: ->
    @attributes.decrementProperty('move.current')

    if @attributes.get('move.current') == 0
      this.acted()
    else
      this.activate()
      this._act() if typeof this._act == 'function'

  moveTo: (destination) ->
    this.tween {x: destination.x, y: destination.y}, Game.engine.movementSpeed, => this.moved()
