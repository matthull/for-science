Game.Router.map ->
  this.route 'sidebar', { path: '/start'}
  #this.route 'playerStatus'

#Game.PlayerStatusRoute = Ember.Route.extend
  #model: ->
    #Game.pc.attributes

Game.SidebarRoute = Ember.Route.extend
  renderTemplate: ->
    statusController = this.controllerFor('playerStatus')
    statusController.set 'model', Game.pc
    this.render 'player-status',
      outlet: 'player-status'
      controller: statusController

    logController = this.controllerFor('logReadout')
    logController.set 'content', Game.logger.logs
    this.render 'log-readout',
      outlet: 'log-readout',
      controller: logController
