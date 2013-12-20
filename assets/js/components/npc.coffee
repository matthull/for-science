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

    @relations = []
    @zoneOfInterest = 5
    @threatDie = Crafty.e('Die').die ['threatened']
    @skittishness = 3

    Crafty.bind 'acted', (actor) =>
      return if actor[0] == this[0]
      if relation = this.relationTo actor
        relation.level += 1 if @threatDie.roll() == 'threatened'
      else if Game.map.totalDistanceBetween(this.location(), actor.location()) <= @zoneOfInterest
        this.addRelationTo actor, 'threat', 0

  addRelationTo: (actor, type, level) ->
    throw "Already has relation of type #{type} with actor #{actor[0]}" if this.relationTo(actor)
    rel = {to: actor, type: type, level: level}
    @relations.push rel
    rel

  relationTo: (actor) ->
    @relations.filter((r) -> r.to == actor)[0]

  removeRelationTo: (actor) ->
    origLength = @relations.length
    @relations = @relations.reject (r) -> r.to[0] == actor[0]
    if @relations.length == origLength then false else true

  _act: ->
    @relations.forEach (r) =>
      if Game.map.totalDistanceBetween(this.location(), r.to.location()) > @zoneOfInterest
        this.removeRelationTo r.to

    #if @mood == 'aggressive'
      #prey = Crafty('Actor').filter (id) => Game.map.totalDistanceBetween(Crafty(id).location(), this.location())
      #this.approach Game.pc
    #else this.wander()
    this.wander()

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
