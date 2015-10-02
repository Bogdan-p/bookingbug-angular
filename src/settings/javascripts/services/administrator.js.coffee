###**
* @ngdoc service
* @name BBAdmin.Services:AdminAdministratorService
*
* @description
* Factory AdminAdministratorService
*
* path: src/settings/javascripts/services/administrator.js.coffee
*
* @requires $q
* @requires BB.Models:BBModel
*
* @returns {Promise} This service has the following set of methods:
*
* - query(params)
*
###

angular.module('BBAdmin.Services').factory 'AdminAdministratorService', ($q, BBModel) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdmin.Services:AdminAdministratorService
  *
  * @description
  * query
  *
  * @param {object} params params
  *
  * @returns {Promise} deferred.promise
  *
  ###

  query: (params) ->
    company = params.company
    defer = $q.defer()
    company.$get('administrators').then (collection) ->
      collection.$get('administrators').then (administrators) ->
        models = (new BBModel.Admin.Administrator(a) for a in administrators)
        defer.resolve(models)
      , (err) ->
        defer.reject(err)
    , (err) ->
      defer.reject(err)
    defer.promise

