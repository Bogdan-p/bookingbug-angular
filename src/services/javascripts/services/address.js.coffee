###**
* @ngdoc service
* @name BBAdmin.Services:AdminAddressService
*
* @description
* Factory AdminAddressService
*
* path: src/services/javascripts/services/address.js.coffee
*
* @requires $q
* @requires BB.Models:BBModel
*
* @returns {Promise} This service has the following set of methods:
*
* - query(params)
*
###
angular.module('BBAdmin.Services').factory 'AdminAddressService',  ($q, BBModel) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdmin.Services:AdminAddressService
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
    company.$get('addresses').then (collection) ->
      collection.$get('addresses').then (addresss) ->
        models = (new BBModel.Admin.Address(s) for s in addresss)
        defer.resolve(models)
      , (err) ->
        defer.reject(err)
    , (err) ->
      defer.reject(err)
    defer.promise

