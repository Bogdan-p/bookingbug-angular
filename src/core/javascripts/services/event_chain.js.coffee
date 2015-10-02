###**
* @ngdoc service
* @name BB.Services:EventChainService
*
* @description
* Factory EventChainService
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
angular.module('BB.Services').factory "EventChainService",  ($q, BBModel) ->
  query: (company, params) ->
    deferred = $q.defer()
    if !company.$has('event_chains')
      deferred.reject("company does not have event_chains")
    else
      company.$get('event_chains', params).then (resource) =>
        resource.$get('event_chains', params).then (event_chains) =>
          event_chains = for event_chain in event_chains
            new BBModel.EventChain(event_chain)
          deferred.resolve(event_chains)
      , (err) =>
        deferred.reject(err)
    deferred.promise
