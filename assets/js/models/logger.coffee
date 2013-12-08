Game.Logger = Ember.Object.extend
  logId: 1
  logs: Ember.A([])

  info: (message) ->
    this.get('logs').pushObject Game.Log.create(logId: this.incrementProperty('logId'), message: message)

  debug: (message) ->
    this.info 'DEBUG: ' + message
