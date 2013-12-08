Game.SidebarController = Ember.ObjectController.extend
  historySize: 10

  recentLogs: (->
    _.last this.get('logs'), this.historySize
  ).property('recentLogs', 'logs')
