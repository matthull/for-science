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
    Crafty.trigger 'acted', this

  moved: ->
    @attributes.decrementProperty('move.current')

    if @attributes.get('move.current') == 0
      this.acted()
    else
      this.activate()
      this._act() if typeof this._act == 'function'

  moveTo: (destination) ->
    distanceFromPlayer = Game.map.distanceBetween this.location(), Game.pc.location()
    transitionSpeed = if Math.max(distanceFromPlayer.x, distanceFromPlayer.y) < 7 then Game.engine.movementSpeed else 0
    this.tween {x: Game.map.tilesToPixels(destination.x), y: Game.map.tilesToPixels(destination.y)}, transitionSpeed, => this.moved()

  location: ->
    x: Game.map.pixelsToTiles(@x)
    y: Game.map.pixelsToTiles(@y)

  destinationNextTo: (target) ->
    possibleDestinations = Game.map.tilesSurrounding target
    # order by nearest to farthest
    possibleDestinations.sort (d) => Game.map.totalDistanceBetween(this.location(), d)
    possibleDestinations[0]

  pathTo: (target) ->
    finder = new PF.AStarFinder();
    destination = this.destinationNextTo target.location()
    if destination == undefined then Game.logger.debug "All adjacent tiles to target are blocked"
    else finder.findPath this.location().x, this.location().y, destination.x, destination.y, this.pathfindingGrid()

  pathfindingGrid: ->
    grid = Game.map.grid()
    if this.location() then grid.setWalkableAt this.location().x, this.location().y, true
    grid
