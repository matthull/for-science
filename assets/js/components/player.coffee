Crafty.c 'Player',
  init: ->
    this.requires 'Tween'
    this.requires 'Actor'
    this.requires('MapObject').mapObject 'PC'
    this.requires('Creature').creature
      agility:
        current: 1
      speed:
        current: 1
      focus:
        current: 1
      detection:
        current: 1
      move:
        current: 0
        max: 1
      endurance:
        current: 6
        max: 6
      hp:
        current: 2
        max: 2
      instability:
        current: 0

    @abilities = [
      Game.Ability.create
        name: 'jog'
        activatedBy: Crafty.keys['1']
        cooldown: 3
        enduring: true
        turnsUntilNextUse: 0
        owner: this
        effect: -> @owner.attributes.set('move.current', 2)
    ]

    this.bind 'KeyDown', (e) =>
      return unless @active
      this.deactivate()

      if e.key == Crafty.keys['H'] then direction = 'left'
      if e.key == Crafty.keys['K'] then direction = 'up'
      if e.key == Crafty.keys['L'] then direction = 'right'
      if e.key == Crafty.keys['J'] then direction = 'down'

      if e.key == Crafty.keys['PERIOD'] then Game.logger.info 'You wait...'; return this.acted()

      ability = this.abilities.filter((a) -> e.key == a.activatedBy)[0]
      if ability
        Game.logger.info 'Attempting to activate ability: ' + ability.name
        ability.activate()

      if direction
        destination = Game.map.relativeLocation
          x: this.x, y: this.y,
          direction,
          tiles: 1

        if (_.some Crafty('Solid'), (e) -> Crafty(e).isAt destination.x+1, destination.y+1)
          return Game.logger.info "You can't go there! Blocked by obstacle"
          return this.activate()

        unless (Game.map.inbounds destination)
          return Game.logger.info "You can't go there! Blocked by edge of map"
          return this.activate()

        this.moveTo destination

      this.activate()
