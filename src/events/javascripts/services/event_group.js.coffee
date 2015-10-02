###**
* @ngdoc service
* @name BBAdminEvents.Services:AdminEventGroupService
*
* @description
* Factory AdminEventGroupService
*
* @requires $q
* @requires BBAdminEvents.Models:BBModel
*
* @returns {Promise} This service has the following set of methods:
*
* - query(params)
*
###

angular.module('BBAdminEvents').factory 'AdminEventGroupService',  ($q, BBModel) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdminEvents.Services:AdminEventGroupService
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
    company.$get('event_groups').then (collection) ->
      collection.$get('event_groups').then (event_groups) ->
        models = (new BBModel.Admin.EventGroup(e) for e in event_groups)
        defer.resolve(models)
      , (err) ->
        defer.reject(err)
    , (err) ->
      defer.reject(err)
    defer.promise



