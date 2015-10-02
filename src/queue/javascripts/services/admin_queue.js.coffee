###**
* @ngdoc service
* @name BBQueue.Services:AdminQueueService
*
* @description
* Factory AdminQueueService
*
* @requires $q
* @requires $window
* @requires halClient
* @requires BB.Models:BBModel
*
* @returns {Promise} This service has the following set of methods:
*
* - query(prms)
*
###

angular.module('BBQueue.Services').factory 'AdminQueueService', ($q, $window, halClient, BBModel) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBQueue.Services:AdminQueueService
  *
  * @description
  * Method query
  *
  * @param {object} prms prms
  *
  * @returns {Promise} deferred.reject(err) or deferred.promise
  *
  ###

  query: (prms) ->
      
    deferred = $q.defer()
    prms.company.$get('client_queues').then (collection) ->
      collection.$get('client_queues').then (client_queues) ->
        models = (new BBModel.Admin.ClientQueue(q) for q in client_queues)
        deferred.resolve(models)
      , (err) ->
        deferred.reject(err)
    , (err) ->
      deferred.reject(err)
    deferred.promise

