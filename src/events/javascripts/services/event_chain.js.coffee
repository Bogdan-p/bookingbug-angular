###**
* @ngdoc service
* @name BBAdminEvents.Services:AdminEventChainService
*
* @description
* Factory AdminEventChainService
*
* @requires $q
* @requires BB.Models:BBModel
*
* @returns {Promise} This service has the following set of methods:
*
* - query(params)
*
###

angular.module('BBAdminEvents').factory 'AdminEventChainService',  ($q, BBModel) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdminEvents.Services:AdminEventChainService
  *
  * @description
  * Method query
  *
  * @param {object} params params
  *
  * @returns {Promise} defer.reject(err) or defer.promise
  *
  ###

  query: (params) ->
    company = params.company
    defer = $q.defer()
    company.$get('event_chains').then (collection) ->
      collection.$get('event_chains').then (event_chains) ->
        models = (new BBModel.Admin.EventChain(e) for e in event_chains)
        defer.resolve(models)
      , (err) ->
        defer.reject(err)
    , (err) ->
      defer.reject(err)
    defer.promise

