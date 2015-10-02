###**
* @ngdoc service
* @name BB.Services:EventSequenceService
*
* @description
* Factory EventSequenceService
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
angular.module('BB.Services').factory "EventSequenceService", ($q, BBModel) ->
  query: (company, params) ->
    deferred = $q.defer()
    if !company.$has('event_sequences')
      deferred.reject("company does not have event_sequences")
    else
      company.$get('event_sequences', params).then (resource) =>
        resource.$get('event_sequences', params).then (event_sequences) =>
          event_sequences = for event_sequence in event_sequences
            new BBModel.EventSequence(event_sequence)
          deferred.resolve(event_sequences)
      , (err) =>
        deferred.reject(err)
    deferred.promise
