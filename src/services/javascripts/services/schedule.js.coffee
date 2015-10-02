###**
* @ngdoc service
* @name BBAdmin.Services:AdminScheduleService
*
* @description
* Factory AdminScheduleService
*
* path: src/services/javascripts/services/schedule.js.coffee
*
* @requires $q
* @requires BB.Models:BBModel
*
* @returns {Promise} This service has the following set of methods:
*
* - query(params)
*
###
angular.module('BBAdmin.Services').factory 'AdminScheduleService',  ($q, BBModel) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdmin.Services:AdminScheduleService
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
    company.$get('schedules').then (collection) ->
      collection.$get('schedules').then (schedules) ->
        models = (new BBModel.Admin.Schedule(s) for s in schedules)
        defer.resolve(models)
      , (err) ->
        defer.reject(err)
    , (err) ->
      defer.reject(err)
    defer.promise

