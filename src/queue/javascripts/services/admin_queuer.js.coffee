###**
* @ngdoc service
* @name BBQueue.Services:AdminQueuerService
*
* @description
* Factory AdminQueuerService
*
* @requires $q
* @requires $window
* @requires halClient
* @requires BB.Models:BBModel
*
* @returns {Promise} This service has the following set of methods:
*
* - query(params)
*
###

angular.module('BBQueue.Services').factory 'AdminQueuerService', ($q, $window, halClient, BBModel) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBQueue.Services:AdminQueuerService
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
    defer = $q.defer()
    params.company.$flush('queuers')
    params.company.$get('queuers').then (collection) ->
      collection.$get('queuers').then (queuers) ->
        models = (new BBModel.Admin.Queuer(q) for q in queuers)
        defer.resolve(models)
      , (err) ->
        defer.reject(err)
    , (err) ->
      defer.reject(err)
    defer.promise
