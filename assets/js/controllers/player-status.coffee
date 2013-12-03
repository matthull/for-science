Game.PlayerStatusController = Ember.Controller.extend
  setupController: (controller) ->
    controller.set 'model', Game.pc.attributes
