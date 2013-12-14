Crafty.c 'Actor',
  init: ->
    this.requires 'Solid'
    @active = false

  act: ->
    this.activate()
    @attributes.set 'move.current', @attributes.get('move.max')

    _.each @abilities, (a) -> a.decrementProperty('turnsUntilNextUse') if a.get('turnsUntilNextUse') > 0

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
    this.tween {x: Game.map.tilesToPixels(destination.x), y: Game.map.tilesToPixels(destination.y)}, Game.engine.movementSpeed, => this.moved()

  location: ->
    x: Game.map.pixelsToTiles(@x)
    y: Game.map.pixelsToTiles(@y)

  destinationNextTo: (target) ->
    # Find if we are above/below or left/right of target
    aboveTarget = this.location().x < target.location().x
    leftOfTarget= this.location().y < target.location()
    # Check 2 nearest tiles to see if they are blocked
    # If both blocked, start expanding search

  pathTo: (target) ->
    finder = new PF.AStarFinder();
    destination = this.destinationNextTo target
    #finder.findPath this.x.tiles, this.y.tiles, destination.x.tiles, destination.y.tiles, Game.map.grid()
