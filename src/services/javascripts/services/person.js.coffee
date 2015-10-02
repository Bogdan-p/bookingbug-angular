###**
* @ngdoc service
* @name BBAdmin.Services:AdminPersonService
*
* @description
* Factory AdminPersonService
*
* path: src/services/javascripts/services/person.js.coffee
*
* @requires $q
* @requires $window
* @requires $rootScope
* @requires $log
* @requires angular-hal:halClient
* @requires BB.Services:SlotCollections
* @requires BB.Models:BBModel
* @requires BB.Services:LoginService
*
* @returns {Promise} This service has the following set of methods:
*
* - query(params)
* - block(company, person, data)
* - signup(user, data)
*
###
angular.module('BBAdminServices').factory 'AdminPersonService',  ($q, $window,
    $rootScope, halClient, SlotCollections, BBModel, LoginService, $log) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdmin.Services:AdminPersonService
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
    if company.$has('people')
      company.$get('people').then (collection) ->
        collection.$get('people').then (people) ->
          models = (new BBModel.Admin.Person(p) for p in people)
          defer.resolve(models)
        , (err) ->
          defer.reject(err)
      , (err) ->
        defer.reject(err)
    else
      $log.warn('company has no people link')
      defer.reject('company has no people link')
    defer.promise

  ###**
  * @ngdoc method
  * @name block
  * @methodOf BBAdmin.Services:AdminPersonService
  *
  * @description
  * block
  *
  * @params {object} params
  * @params {object} person
  * @params {object} data
  *
  * @returns {Promise} deferred.promise
  *
  ###
  block: (company, person, data) ->
    deferred = $q.defer()
    person.$put('block', {}, data).then  (slot) =>
      slot = new BBModel.Admin.Slot(slot)
      SlotCollections.checkItems(slot)
      deferred.resolve(slot)
    , (err) =>
      deferred.reject(err)

    deferred.promise

  ###**
  * @ngdoc signup
  * @name query
  * @methodOf BBAdmin.Services:AdminPersonService
  *
  * @description
  * block
  *
  * @params {object} user
  * @params {object} data
  *
  * @returns {Promise} deferred.promise
  *
  ###
  signup: (user, data) ->
    defer = $q.defer()
    user.$get('company').then (company) ->
      params = {}
      company.$post('people', params, data).then (person) ->
        if person.$has('administrator')
          person.$get('administrator').then (user) ->
            LoginService.setLogin(user)
            defer.resolve(person)
        else
          defer.resolve(person)
      , (err) ->
        defer.reject(err)
      defer.promise

