###**
* @ngdoc service
* @name BB.Services:EventGroupService
*
* @description
* Factory EventGroupService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
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
angular.module('BB.Services').factory "EventGroupService",  ($q, BBModel) ->
  query: (company, params) ->
    deferred = $q.defer()
    if !company.$has('event_groups')
      deferred.reject("company does not have event_groups")
    else
      company.$get('event_groups', params).then (resource) =>
        resource.$get('event_groups', params).then (event_groups) =>
          event_groups = for event_group in event_groups
            new BBModel.EventGroup(event_group)
          deferred.resolve(event_groups)
      , (err) =>
        deferred.reject(err)
    deferred.promise
