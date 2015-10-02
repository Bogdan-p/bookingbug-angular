###**
* @ngdoc service
* @name BBAdmin.Services:AdminServiceService
*
* @description
* Factory AdminServiceService
*
* path: src/services/javascripts/services/service.js.coffee
*
* @requires $q
* @requires $log
* @requires BB.Models:BBModel
*
* @returns {Promise} This service has the following set of methods:
*
* - query(params)
*
###
angular.module('BBAdmin.Services').factory 'AdminServiceService', ($q, BBModel, $log) ->

	###**
	* @ngdoc method
	* @name query
	* @methodOf BBAdmin.Services:AdminServiceService
	*
	* @description
	* query
	*
	* @params {object} params
	*
	* @returns {Promise} deferred.promise
	*
	###
	query: (params) ->
		company = params.company
		defer = $q.defer()
		company.$get('services').then (collection) ->
			collection.$get('services').then (services) ->
				models = (new BBModel.Admin.Service(s) for s in services)
				defer.resolve(models)
			,	(err) ->
				defer.reject(err)
		,	(err) ->
			defer.reject(err)
		defer.promise
