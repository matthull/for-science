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
        activatedBy: '1'
        cooldown: 3
        enduring: true
        turnsUntilNextUse: 0
        owner: this
        effect: -> @owner.attributes.set('move.current', 2)
    ]

    @moveKeys = [
      activatedBy: 'H'
      name: 'left'
    ,
      activatedBy: 'K'
      name: 'up'
    ,
      activatedBy: 'L'
      name: 'right'
    ,
      activatedBy: 'J'
      name: 'down'
    ,
      activatedBy: 'LEFT_ARROW'
      name: 'left'
    ,
      activatedBy: 'UP_ARROW'
      name: 'up'
    ,
      activatedBy: 'RIGHT_ARROW'
      name: 'right'
    ,
      activatedBy: 'DOWN_ARROW'
      name: 'down'
    ]

    this.bind 'KeyDown', (e) =>
      return unless @active
      this.deactivate()

      ability = @abilities.filter((a) -> e.key == Crafty.keys[a.activatedBy])[0]
      direction = @moveKeys.filter((m) -> e.key == Crafty.keys[m.activatedBy])[0]

      if e.key == Crafty.keys['PERIOD'] then Game.logger.info 'You wait...'; return this.acted()
      return this.activate() unless ability or direction

      if ability
        Game.logger.info 'Attempting to activate ability: ' + ability.name
        ability.activate()
        return this.activate()

      if direction
        destination = Game.map.relativeLocation
          x: this.x, y: this.y,
          direction.name,
          tiles: 1

        if (_.some Crafty('Solid'), (e) -> Crafty(e).isAt destination.x+1, destination.y+1)
          return Game.logger.info "You can't go there! Blocked by obstacle"
          return this.activate()

        unless (Game.map.inbounds destination)
          return Game.logger.info "You can't go there! Blocked by edge of map"
          return this.activate()

        this.moveTo destination
