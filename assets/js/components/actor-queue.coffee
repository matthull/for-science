Crafty.c 'ActorQueue',
  init: ->
    @actors = []
    @index = 0

  append: (actor) ->
    @actors.push actor

  remove: (actor) ->
    @actors = _.reject @actors, (a) -> a.actorId == actor.actorId

  current: ->
    @actors[@index]

  advance: ->
    current = this.current()
    if @index == @actors.length - 1 then @index = 0 else @index++
    current
