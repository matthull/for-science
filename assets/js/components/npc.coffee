Crafty.c 'NPC',
  init: ->
    this.requires('Creature').creature
      agility: 1
      speed: 1
      focus: 1
      detection: 1
      endurance: 4
      hp: 3

    this.requires 'Tween'
    this.requires 'Actor'
    this.requires('MapObject').mapObject 'Creature1'

  _act: ->
    options = [ 'wait', 'move' ]
    return @acted() if _.sample(options) == 'wait'

    directions = [
      {vertical: 1, horizontal: 0},
      {vertical: -1, horizontal: 0},
      {vertical: 0, horizontal: -1},
      {vertical: 0, horizontal: 1}
    ]

    availableDirections = _.filter directions, (direction) =>
      not _.some Crafty('Solid'), (e) =>
        Crafty(e).isAt this.x + (direction.horizontal * Game.engine.tileSize) + 1, this.y + (direction.vertical * Game.engine.tileSize) + 1

    availableDirections = _.filter availableDirections, (direction) =>
      Game.map.inbounds this.x + (direction.horizontal * Game.engine.tileSize) + 1, this.y + (direction.vertical * Game.engine.tileSize) + 1

    return @acted() if availableDirections.length == 0
    chosenDirection = _.sample availableDirections

    destination = {}
    destination.x = this.x + (chosenDirection.horizontal * Game.engine.tileSize)
    destination.y = this.y + (chosenDirection.vertical * Game.engine.tileSize)

    this.tween {x: destination.x, y: destination.y}, Game.engine.movementSpeed, => @acted()
