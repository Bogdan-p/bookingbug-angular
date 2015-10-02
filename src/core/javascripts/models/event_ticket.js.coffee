

'use strict';

###**
* @ngdoc object
* @name BB.Models:EventTicketModel
*
* @description
* This is EventTicketModel in BB.Models module that creates EventTicket object.
*
* <pre>
* //Creates class EventTicket that extends BaseModel
* class EventTicket extends BaseModel
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
* @returns {object} Newly created EventTicket object with the following set of methods:
*
* - constructor(data)
* - fullName()
* - getRange(cap)
* - totalQty()
* - getMax(cap, ev = null)
* - add(value)
* - subtract(value)
*
###
angular.module('BB.Models').factory "EventTicketModel", ($q, BBModel, BaseModel) ->

  class EventTicket extends BaseModel


    constructor: (data) ->
      super(data)

      @max = @max_num_bookings

      if @max_spaces
        ms = @max_spaces
        ms = @max_spaces / @counts_as if @counts_as
        if ms < max
          @max = ms


    fullName: () ->
      if @pool_name
        return @pool_name + " - " + @name
      @name


    getRange: (cap) ->
      if cap
        c = cap
        c = cap / @counts_as if @counts_as
        if c + @min_num_bookings < @max
          @max = c + @min_num_bookings

      [0].concat [@min_num_bookings..@max]

    totalQty: () ->
      return 0 if !@qty
      return @qty if !@counts_as
      return @qty * @counts_as


    # get the max - this looks at an optional cap, the maximum available and potential a running count of tickest already selected (from passing in the event being booked)
    getMax: (cap, ev = null) ->
      live_max = @max
      if ev
        used = 0
        for ticket in ev.tickets
          used += ticket.totalQty()
        if @qty
          used = used - @totalQty()
        if @counts_as
          used = Math.ceil(used/@counts_as)

        live_max = live_max - used
        live_max = 0 if live_max < 0
      if cap
        c = cap
        c = cap / @counts_as if @counts_as
        if c + @min_num_bookings < live_max
          return c + @min_num_bookings
      return live_max


    add: (value) ->
      @qty = 0 if !@qty
      @qty = parseInt(@qty)

      return if angular.isNumber(@qty) and (@qty >= @max and value > 0) or (@qty is 0 and value < 0)
      @qty += value


    subtract: (value) ->
      @add(-value)

