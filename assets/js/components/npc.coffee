Crafty.c 'NPC',
  init: ->
    this.requires('Creature').creature
      agility: 1
      speed: 1
      focus: 1
      detection: 1
      move:
        current: 0
        max: 2
      endurance:
        current: 2
        max: 2
      hp:
        current: 2
        max: 2

    this.requires 'Tween'
    this.requires 'Actor'
    this.requires('MapObject').mapObject 'Creature1'

  _act: ->
    options = [ 'wait', 'move' ]
    if _.sample(options) == 'wait' then Game.logger.info 'Creature is waiting...'; return this.acted()

    destinations = _.map ['left', 'up', 'down', 'right'], (direction) =>
      Game.map.relativeLocation
        x: @x, y: @y,
        direction,
        tiles: 1

    availableDestinations = _.filter destinations, (destination) =>
      (not _.some Crafty('Solid'), (e) => Crafty(e).isAt destination.x, destination.y) and (Game.map.inbounds destination)

    return this.acted() if availableDestinations.length == 0
    chosenDestination = _.sample availableDestinations

    this.tween {x: chosenDestination.x, y: chosenDestination.y}, Game.engine.movementSpeed, => this.moved()
