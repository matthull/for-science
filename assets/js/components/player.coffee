Crafty.c 'Player',
  init: ->
    this.requires 'Tween'
    this.requires 'Actor'
    this.requires('MapObject').mapObject 'PC'
    this.requires('Creature').creature
      agility: 1
      speed: 1
      focus: 1
      detection: 1
      move: 2
      endurance:
        current: 2
        max: 2
      hp:
        current: 2
        max: 2

    this.bind 'KeyDown', (e) =>
      return unless @active
      @deactivate()

      if (e.key == Crafty.keys['H']) then direction = 'left'
      if (e.key == Crafty.keys['K']) then direction = 'up'
      if (e.key == Crafty.keys['L']) then direction = 'right'
      if (e.key == Crafty.keys['J']) then direction = 'down'

      if direction
        destination = Game.map.relativeLocation
          x: this.x, y: this.y,
          direction,
          tiles: 1

        if (_.some Crafty('Solid'), (e) -> Crafty(e).isAt destination.x+1, destination.y+1)
          this.activate()
          return console.log 'Blocked by obstacle'

        unless (Game.map.inbounds destination)
          this.activate()
          return console.log 'Blocked by edge of map'

        this.moveTo destination

      if (e.key == Crafty.keys['PERIOD']) then console.log 'Waiting...'; return @acted()
