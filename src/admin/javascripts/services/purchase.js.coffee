###**
* @ngdoc service
* @name  BBAdmin.Services:AdminPurchaseService
*
* @description
* Factory AdminPurchaseService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q read more}
*
* @param {model} halClient Info param
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more
*
###
angular.module('BBAdmin.Services').factory 'AdminPurchaseService',  ($q, halClient, BBModel) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdmin.Services:AdminPurchaseService
  *
  * @description
  * Method query
  *
  * @param {object} params Info
  *
  * @returns {Promise} defer.reject(err) or deferred.promise
  ###
  query: (params) ->
    defer = $q.defer()
    uri = params.url_root+"/api/v1/admin/purchases/"+params.purchase_id
    halClient.$get(uri, params).then (purchase) ->
      purchase = new BBModel.Purchase.Total(purchase)
      defer.resolve(purchase)
    , (err) ->
      defer.reject(err)
    defer.promise

  ###**
  * @ngdoc method
  * @name markAsPaid
  * @methodOf BBAdmin.Services:AdminPurchaseService
  *
  * @description
  * Method markAsPaid
  *
  * @param {object} params Info
  *
  * @returns {Promise} defer.reject(err) or deferred.promise
  ###
  markAsPaid: (params) ->
    defer = $q.defer()

    if !params.purchase or !params.url_root
      defer.reject("invalid request")
      return defer.promise

    if params.company
      company_id = params.company.id

    uri = params.url_root+"/api/v1/admin/#{company_id}/purchases/#{params.purchase.id}/pay"
    halClient.$put(uri, params).then (purchase) ->
      purchase = new BBModel.Purchase.Total(purchase)
      defer.resolve(purchase)
    , (err) ->
      defer.reject(err)
    defer.promise

