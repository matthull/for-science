Game.Ability = Ember.Object.extend
  init: ->
    @turnsUntilNextUse = 0

  activate: ->
    return Game.logger.info @turnsUntilNextUse + ' turns until ' + @name + ' is available' if @turnsUntilNextUse > 0
    this.effect()
    Game.logger.info 'Ability activated: ' + @name
    if @enduring
      #@owner.attributes.decrementProperty('endurance.current')
      die = [ 'endure', '-', '-', '-', '-', '-' ]
      enduranceTest = @owner.rollAgainst(die, 'endurance')
      Game.logger.info 'Rolled endurance test with results: ' + enduranceTest.join()

    if @enduring and 'endure' in enduranceTest
      Game.logger.info 'Passed endurance test - cooldown cancelled for ' + @name
      @turnsUntilNextUse = 1
    else if @enduring
      Game.logger.info 'Failed endurance test for ' + @name + '. Cooldown in effect.'
      @turnsUntilNextUse = @cooldown
    else
      @turnsUntilNextUse = @cooldown

    if @endsTurn then @owner.acted() else @owner.activate()
