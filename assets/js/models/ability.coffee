Game.Ability = Ember.Object.extend
  init: ->
    this.set 'turnsUntilNextUse', 0

  available: (->
    this.get('turnsUntilNextUse') == 0
  ).property('turnsUntilNextUse')

  activate: ->
    unless this.get('available')
      @owner.activate()
      return Game.logger.info this.get('turnsUntilNextUse') + ' turns until ' + @name + ' is available'

    this.effect()
    Game.logger.info 'Ability activated: ' + @name
    if @enduring
      #@owner.attributes.decrementProperty('endurance.current')
      die = [ 'endure', '-', '-', '-', '-', '-' ]
      enduranceTest = @owner.rollAgainst(die, 'endurance')
      Game.logger.info 'Rolled endurance test with results: ' + enduranceTest.join()

    if @enduring and 'endure' in enduranceTest
      Game.logger.info 'Passed endurance test - cooldown cancelled for ' + @name
      this.set 'turnsUntilNextUse', 1
    else if @enduring
      Game.logger.info 'Failed endurance test for ' + @name + '. Cooldown in effect.'
      this.set 'turnsUntilNextUse', this.get('cooldown')
    else
      this.set 'turnsUntilNextUse', this.get('cooldown')

    if @endsTurn then @owner.acted() else @owner.activate()
