###**
* @ngdoc service
* @name BBQueue.Services:QueuerService
*
*@description
* Factory QueuerService
*
* @requires $q
* @requires $window
* @requires halClient
* @requires BB.Models:BBModel
*
* @returns {Promise} This service has the following set of methods:
*
* - query(params)
* - removeFromQueue(params)
*
###

angular.module('BBQueue.Services').factory('QueuerService', ["$q", "$window", "halClient", "BBModel", ($q, UriTemplate, halClient, BBModel) ->

	###**
  * @ngdoc method
  * @name query
  * @methodOf BBQueue.Services:QueuerService
  *
  * @description
  * Method query
  *
  * @param {object} params params
  *
  * @returns {Promise} deferred.promise
  *
  ###

	query: (params) ->
		deferred = $q.defer()

		url = ""
		url = params.url if params.url
		href = url + "/api/v1/queuers/{id}"
		uri = new UriTemplate(href).fillFromObject(params || {})

		halClient.$get(uri, {}).then (found) =>
			deferred.resolve(found)

		deferred.promise

	###**
  	* @ngdoc method
  	* @name removeFromQueue
  	* @methodOf BBQueue.Services:QueuerService
  	*
  	* @description
  	* Method removeFromQueue
  	*
  	* @param {object} params params
  	*
  	* @returns {Promise} deferred.promise
  	*
  	###

	removeFromQueue: (params) ->
		deferred = $q.defer()

		url = ""
		url = params.url if params.url
		href = url + "/api/v1/queuers/{id}"
		uri = new UriTemplate(href).fillFromObject(params || {})

		halClient.$del(uri).then (found) =>
			deferred.resolve(found)

		deferred.promise

])

