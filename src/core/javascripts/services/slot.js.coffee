###**
* @ngdoc service
* @name BB.Services:SlotService
*
* @description
* Factory SlotService
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
* - query(company, params)
*
###
angular.module('BB.Services').factory "SlotService", ($q, BBModel) ->
  query: (company, params) ->
    deferred = $q.defer()
    if !company.$has('slots')
      deferred.resolve([])
    else
      if params.item
        params.resource_id = params.item.resource.id if params.item.resource
        params.person_id = params.item.person.id if params.item.person
      company.$get('slots', params).then (resource) =>
        resource.$get('slots', params).then (slots) =>
          slots = (new BBModel.Slot(slot) for slot in slots)
          deferred.resolve(slots)
      , (err) =>
        deferred.reject(err)
    deferred.promise

