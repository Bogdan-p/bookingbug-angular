###**
* @ngdoc service
* @name BBAdmin.Services:AdminClinicService
*
* @description
* Factory AdminClinicService
*
* path: src/services/javascripts/services/clinic.js.coffee
*
* @requires $q
* @requires $window
* @requires BB.Models:BBModel
* @requires BBAdmin.Services.ClinicCollections
*
* @returns {Promise} This service has the following set of methods:
*
* - query(params)
* - create(prms, clinic)
* - delete(clinic)
* - update: (clinic)
*
###
angular.module('BBAdmin.Services').factory 'AdminClinicService',  ($q, BBModel, ClinicCollections, $window) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdmin.Services:AdminClinicService
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

    existing = ClinicCollections.find(params)
    if existing
      defer.resolve(existing)
    else
      company.$get('clinics').then (collection) ->
        collection.$get('clinics').then (clinics) ->
          models = (new BBModel.Admin.Clinic(s) for s in clinics)
          clinics = new $window.Collection.Clinic(collection, models, params)
          ClinicCollections.add(clinics)
          defer.resolve(clinics)
        , (err) ->
          defer.reject(err)
      , (err) ->
        defer.reject(err)
    defer.promise

  ###**
  * @ngdoc method
  * @name create
  * @methodOf BBAdmin.Services:AdminClinicService
  *
  * @description
  * create
  *
  * @params {object} params
  * @params {object} clinic
  *
  * @returns {Promise} deferred.promise
  *
  ###
  create: (prms, clinic) ->
    company = prms.company
    deferred = $q.defer()
    company.$post('clinics', {}, clinic.getPostData()).then  (clinic) =>
      clinic = new BBModel.Admin.Clinic(clinic)
      ClinicCollections.checkItems(clinic)
      deferred.resolve(clinic)
    , (err) =>
      deferred.reject(err)

    deferred.promise

  ###**
  * @ngdoc method
  * @name delete
  * @methodOf BBAdmin.Services:AdminClinicService
  *
  * @description
  * delete
  *
  * @params {object} clinic
  *
  * @returns {Promise} deferred.promise
  *
  ###
  delete: (clinic) ->
    deferred = $q.defer()
    clinic.$del('self').then  (clinic) =>
      clinic = new BBModel.Admin.Clinic(clinic)
      ClinicCollections.deleteItems(clinic)
      deferred.resolve(clinic)
    , (err) =>
      deferred.reject(err)

    deferred.promise

  ###**
  * @ngdoc method
  * @name update
  * @methodOf BBAdmin.Services:AdminClinicService
  *
  * @description
  * update
  *
  * @params {object} clinic
  *
  * @returns {Promise} deferred.promise
  *
  ###
  update: (clinic) ->
    deferred = $q.defer()
    clinic.$put('self', {}, clinic.getPostData()).then (c) =>
      clinic = new BBModel.Admin.Clinic(c)
      ClinicCollections.checkItems(clinic)
      deferred.resolve(clinic)
    , (err) =>
      deferred.reject(err)

    deferred.promise
