###**
* @ngdoc service
* @name BB.Services:TimeSlotService
*
* @description
* Factory TimeSlotService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @returns {Promise} This service has the following set of methods:
*
* - query(params)
*
###
angular.module('BB.Services').factory 'TimeSlotService', ($q, BBModel) ->

  query: (params) ->
    defer = $q.defer()
    company = params.company
    company.$get('slots', params).then (collection) ->
      collection.$get('slots').then (slots) ->
        slots = (new BBModel.TimeSlot(s) for s in slots)
        defer.resolve(slots)
      , (err) ->
        defer.reject(err)
    , (err) ->
      defer.reject(err)
    defer.promise

