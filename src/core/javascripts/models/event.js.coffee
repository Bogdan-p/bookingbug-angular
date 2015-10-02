
'use strict';

###**
* @ngdoc object
* @name BB.Models:EventModel
*
* @description
* This is EventModel in BB.Models module that creates Event object.
*
* <pre>
* //Creates class Event that extends BaseModel
* class Event extends BaseModel
* </pre>
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* * <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {model} BaseModel Info
* <br>
* {@link BB.Models:BaseModel more}
*
* @param {model} DateTimeUlititiesService Info
* <br>
* {@link BB.Services:DateTimeUlititiesService more}
*
* @returns {object} Newly created Event object with the following set of methods:
*
* - constructor(data)
* - getGroup()
* - getChain()
* - getDate()
* - dateString()
* - getDuration()
* - printDuration()
* - getDescription()
* - getColour()
* - getPerson()
* - getPounds()
* - getPrice()
* - getPence()
* - vgetNumBooked()
* - getSpacesLeft(pool = null)
* - hasSpace()
* - hasWaitlistSpace()
* - getRemainingDescription()
* - select()
* - unselect()
* - prepEvent()
* - updatePrice()
*
###
angular.module('BB.Models').factory "EventModel", ($q, BBModel, BaseModel, DateTimeUlititiesService) ->


  class Event extends BaseModel
    constructor: (data) ->
      super(data)
      @getDate()
      @time = new BBModel.TimeSlot(time: DateTimeUlititiesService.convertMomentToTime(@date))
      @end_datetime = @date.clone().add(@duration, 'minutes') if @duration

    getGroup: () ->
      defer = $q.defer()
      if @group
        defer.resolve(@group)
      else if @$has('event_groups')
        @$get('event_groups').then (group) =>
          @group = new BBModel.EventGroup(group)
          defer.resolve(@group)
        , (err) ->
          defer.reject(err)
      else
        defer.reject("No event group")
      defer.promise

    getChain: () ->
      defer = $q.defer()
      if @chain
        defer.resolve(@chain)
      else
        if @$has('event_chains')
          @$get('event_chains').then (chain) =>
            @chain = new BBModel.EventChain(chain)
            defer.resolve(@chain)
        else
          defer.reject("No event chain")
      defer.promise

    getDate: () ->
      return @date if @date
      @date = moment(@_data.datetime)
      return @date

    dateString: (str) ->
      date = @date()
      if date then date.format(str)

    getDuration: () ->
      defer = new $q.defer()
      if @duration
        defer.resolve(@duration)
      else
        @getChain().then (chain) =>
          @duration = chain.duration
          defer.resolve(@duration)
      defer.promise

    printDuration: () ->
      if @duration < 60
        @duration + " mins"
      else
        h = Math.round(@duration / 60)
        m = @duration % 60
        if m == 0
          h + " hours"
        else
          h + " hours " + m + " mins"

    getDescription: () ->
      @getChain().description

    getColour: () ->
      if @getGroup()
        return @getGroup().colour
      else
        return "#FFFFFF"

    getPerson: () ->
      @getChain().person_name

    getPounds: () ->
      if @chain
        Math.floor(@getPrice()).toFixed(0)

    getPrice: () ->
      0

    getPence: () ->
      if @chain
        (@getPrice() % 1).toFixed(2)[-2..-1]

    getNumBooked: () ->
      @spaces_blocked + @spaces_booked + @spaces_reserved + @spaces_held

    # get the number of spaces left (possibly limited by a specific ticket pool)
    getSpacesLeft: (pool = null) ->
      if pool && @ticket_spaces && @ticket_spaces[pool]
        return @ticket_spaces[pool].left
      return @num_spaces - @getNumBooked()

    hasSpace: () ->
      (@getSpacesLeft() > 0)

    hasWaitlistSpace: () ->
      (@getSpacesLeft() <= 0 && @getChain().waitlength > @spaces_wait)

    getRemainingDescription: () ->
      left = @getSpacesLeft()
      if left > 0 && left < 3
        return "Only " + left + " " + (if left > 1 then "spaces" else "space") + " left"
      if @hasWaitlistSpace()
        return "Join Waitlist"
      return ""

    select: ->
      @selected = true

    unselect: ->
      delete @selected if @selected


    prepEvent: () ->
      # build out some useful event stuff
      def = $q.defer()
      @getChain().then () =>

        if @chain.$has('address')
          @chain.getAddressPromise().then (address) =>
            @chain.address = address

        @chain.getTickets().then (tickets) =>
          @tickets = tickets

          @price_range = {}
          if tickets and tickets.length > 0
            for ticket in @tickets
              @price_range.from = ticket.price if !@price_range.from or (@price_range.from and ticket.price < @price_range.from)
              @price_range.to = ticket.price if !@price_range.to or (@price_range.to and ticket.price > @price_range.to)
              ticket.old_price = ticket.price
          else
            @price_range.from  = @price
            @price_range.to = @price

          def.resolve()
      def.promise

    updatePrice: () ->
      for ticket in @tickets
        if ticket.pre_paid_booking_id
          ticket.price = 0
        else
          ticket.price = ticket.old_price

