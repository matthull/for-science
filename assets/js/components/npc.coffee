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

    @zoneSize = 5

    this.requires 'Tween'
    this.requires 'Actor'

  _act: ->
    if @mood == 'aggressive'
      prey = Crafty('Actor').filter (id) => Game.map.totalDistanceBetween(Crafty(id).location(), this.location())
      this.approach Game.pc
    else this.wander()

  approach: (target) ->
    return this.wait() if Game.map.totalDistanceBetween(this.location(), target.location()) == 1
    path = this.pathTo target
    if path[1] then this.moveTo x: path[1][0], y: path[1][1]
    else this.wait()

  wander: ->
    options = [ 'wait', 'move' ]
    if _.sample(options) == 'wait' then return this.wait()

    destinations = _.map ['left', 'up', 'down', 'right'], (direction) =>
      Game.map.relativeLocation this.location(), direction, 1

    availableDestinations = _.filter destinations, (destination) =>
      not Game.map.blocked destination

    return this.acted() if availableDestinations.length == 0
    chosenDestination = _.sample availableDestinations

    this.moveTo chosenDestination

  wait: ->
    Game.logger.info 'Creature is waiting...'
    return this.acted()
