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

    @abilities =
      movementAbilityOne:
        Game.Ability.create
          name: 'Jog'
          cooldown: 3
          enduring: true
          owner: this
          effect: -> @owner.attributes.set('move.current', 2)
      restAbilityOne:
        Game.Ability.create
          name: 'Wait'
          cooldown: 1
          endsTurn: true
          owner: this
          effect: -> Game.logger.info 'Player waiting...'

    this.bind 'KeyDown', (e) =>
      return unless @active
      this.deactivate()

      action = @actions.filter((a) -> e.key == Crafty.keys[a.activatedBy])[0]

      return this.activate() unless action

      if action.type == 'ability'
        @abilities[action.name].activate()

      if action.type == 'move'
        destination = Game.map.relativeLocation this.location(), action.name, 1

        if Game.map.blocked destination
          Game.logger.info "You can't go there! Your path is blocked"
          return this.activate()

        this.moveTo destination

    @actions = [
      activatedBy: 'H'
      type: 'move'
      name: 'left'
    ,
      activatedBy: 'K'
      type: 'move'
      name: 'up'
    ,
      activatedBy: 'L'
      type: 'move'
      name: 'right'
    ,
      activatedBy: 'J'
      type: 'move'
      name: 'down'
    ,
      activatedBy: 'LEFT_ARROW'
      type: 'move'
      name: 'left'
    ,
      activatedBy: 'UP_ARROW'
      type: 'move'
      name: 'up'
    ,
      activatedBy: 'RIGHT_ARROW'
      type: 'move'
      name: 'right'
    ,
      activatedBy: 'DOWN_ARROW'
      type: 'move'
      name: 'down'
    ,
      activatedBy: '1'
      type: 'ability'
      name: 'movementAbilityOne'
    ,
      activatedBy: 'PERIOD'
      type: 'ability'
      name: 'restAbilityOne'
    ]
