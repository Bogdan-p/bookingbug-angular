###**
* @ngdoc service
* @name BB.Services:EventService
*
* @description
* Factory EventService
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
* - query(company, params)
* - summary(company, params)
*
###
angular.module('BB.Services').factory "EventService", ($q, BBModel) ->
  query: (company, params) ->
    deferred = $q.defer()
    if !company.$has('events')
      deferred.resolve([])
    else
      if params.item
        params.event_group_id = params.item.event_group.id if params.item.event_group
        params.event_chain_id = params.item.event_chain.id if params.item.event_chain
        params.resource_id = params.item.resource.id if params.item.resource
        params.person_id = params.item.person.id if params.item.person
      company.$get('events', params).then (resource) =>
        resource.$get('events', params).then (events) =>
          events = (new BBModel.Event(event) for event in events)
          deferred.resolve(events)
      , (err) =>
        deferred.reject(err)
    deferred.promise


  summary: (company, params) ->
    deferred = $q.defer()
    if !company.$has('events')
      deferred.resolve([])
    else
      if params.item
        params.event_group_id = params.item.event_group.id if params.item.event_group
        params.event_chain_id = params.item.event_chain.id if params.item.event_chain
        params.resource_id = params.item.resource.id if params.item.resource
        params.person_id = params.item.person.id if params.item.person
      params.summary = true
      company.$get('events', params).then (resource) =>
        deferred.resolve(resource.events)
      , (err) =>
        deferred.reject(err)
    deferred.promise
