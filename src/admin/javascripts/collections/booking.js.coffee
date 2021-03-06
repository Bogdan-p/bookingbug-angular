class window.Collection.Booking extends window.Collection.Base


  checkItem: (item) ->
    super

  matchesParams: (item) ->
    if @params.start_date?
      @start_date ?= moment(@params.date)
      return false if @start_date.isAfter(item.start)
    if @params.end_date?
      @end_date ?= moment(@params.end_date)
      return false if @end_date.isBefore(item.start.clone().startOf('day'))
    return false if !@params.include_cancelled && item.is_cancelled
    return true

###**
* @ngdoc object
* @name BB.Services:BookingCollections
*
* @description
* It creates new Booking Collections
*
* # Has the following set of methods:
* - $get
*
###

angular.module('BB.Services').provider "BookingCollections", () ->
  $get: ->
    new  window.BaseCollections()
