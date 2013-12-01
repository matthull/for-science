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
      endurance: 2
      hp: 1

    this.bind 'KeyDown', (e) =>
      return unless @active
      @deactivate()
      destination = { x: this.x, y: this.y }
      if (e.key == Crafty.keys['H']) then destination.x = this.x - Game.engine.tileSize
      if (e.key == Crafty.keys['L']) then destination.x = this.x + Game.engine.tileSize
      if (e.key == Crafty.keys['J']) then destination.y = this.y + Game.engine.tileSize
      if (e.key == Crafty.keys['K']) then destination.y = this.y - Game.engine.tileSize
      if (e.key == Crafty.keys['PERIOD']) then console.log 'Waiting...'; return @acted()

      if (_.some Crafty('Solid'), (e) -> Crafty(e).isAt destination.x+1, destination.y+1)
        @act()
        return console.log 'Blocked by obstacle'

      unless (Game.map.inbounds(destination.x, destination.y))
        @act()
        return console.log 'Blocked by edge of map'

      this.tween {x: destination.x, y: destination.y}, Game.engine.movementSpeed, => @acted()
