###**
* @ngdoc service
* @name BBAdmin.Services:AdminResourceService
*
* @description
* Factory AdminResourceService
*
* path: src/services/javascripts/services/resource.js.coffee
*
* @requires $q
* @requires UriTemplate
* @requires angular-hal:halClient
* @requires BB.Services:SlotCollections
* @requires BB.Models:BBModel
*
* @returns {Promise} This service has the following set of methods:
*
* - query(params)
* - block(company, resource, data)
*
###
angular.module('BBAdmin.Services').factory 'AdminResourceService',
($q, UriTemplate, halClient, SlotCollections, BBModel) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdmin.Services:AdminResourceService
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
    company.$get('resources').then (collection) ->
      collection.$get('resources').then (resources) ->
        models = (new BBModel.Admin.Resource(r) for r in resources)
        defer.resolve(models)
      , (err) ->
        defer.reject(err)
    , (err) ->
      defer.reject(err)
    defer.promise

  ###**
  * @ngdoc method
  * @name block
  * @methodOf BBAdmin.Services:AdminResourceService
  *
  * @description
  * block
  *
  * @params {object} params
  * @params {string} resource
  * @params {object} data
  *
  * @returns {Promise} deferred.promise
  *
  ###
  block: (company, resource, data) ->
    prms = {id:  resource.id, company_id: company.id}

    deferred = $q.defer()
    href = "/api/v1/admin/{company_id}/resource/{id}/block"
    uri = new UriTemplate(href).fillFromObject(prms || {})

    halClient.$put(uri, {}, data).then  (slot) =>
      slot = new BBModel.Admin.Slot(slot)
      SlotCollections.checkItems(slot)
      deferred.resolve(slot)
    , (err) =>
      deferred.reject(err)

    deferred.promise
