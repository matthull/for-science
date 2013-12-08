Game.LogReadoutController = Ember.ArrayController.extend
  historySize: 10

  sortProperties: ['logId']
  sortAscending: false

  recentLogs: (->
    logs = _.last(this.get('content'), 10)

    Ember.ArrayProxy.createWithMixins Ember.SortableMixin,
      content: logs
      sortProperties: this.sortProperties
      sortAscending: this.sortAscending
  ).property('@each.message')
