

'use strict';

###**
* @ngdoc object
* @name BB.Models:EventChainModel
*
* @description
* This is EventChainModel in BB.Models module that creates EventChain object.
*
* <pre>
* //Creates class EventChain that extends BaseModel
* class EventChain extends BaseModel
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
* @returns {object} Newly created EventChain object with the following set of methods:
*
* - name()
* - isSingleBooking()
* - hasTickets()
* - getTickets()
* - adjustTicketsForRemaining()
*
###
angular.module('BB.Models').factory "EventChainModel", ($q, BBModel, BaseModel) ->

  class EventChain extends BaseModel
    name: () ->
      @_data.name


    isSingleBooking: () ->
      return @max_num_bookings == 1 && !@$has('ticket_sets')

    hasTickets: () ->
      @$has('ticket_sets')

    getTickets: () ->
      def = $q.defer()
      if @tickets
        def.resolve(@tickets)
      else
        if @$has('ticket_sets')
          @$get('ticket_sets').then (tickets) =>
            @tickets = []
            for ticket in tickets
              @tickets.push(new BBModel.EventTicket(ticket))
            @adjustTicketsForRemaining()
            def.resolve(@tickets)
        else
          @tickets = [new BBModel.EventTicket(
            name: "Admittance"
            min_num_bookings: 1
            max_num_bookings: @max_num_bookings
            type: "normal"
            price: @price
          )]
          @adjustTicketsForRemaining()
          def.resolve(@tickets)
      return def.promise


    # for each ticket set - adjust the number of tickets that can be booked due to changes in the number of remaining spaces
    adjustTicketsForRemaining: () ->
      if @tickets
        for @ticket in @tickets
          @ticket.max_spaces = @spaces
