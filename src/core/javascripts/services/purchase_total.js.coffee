###**
* @ngdoc service
* @name BB.Services:PurchaseTotalService
*
* @description
* Factory PurchaseTotalService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @returns {Promise} This service has the following set of methods:
*
* - query(prms)
*
###
angular.module('BB.Services').factory "PurchaseTotalService", ($q, BBModel) ->
  query: (prms) ->
    deferred = $q.defer()
    if !prms.company.$has('total')
      deferred.reject("No Total link found")
    else
      prms.company.$get('total', {total_id: prms.total_id } ).then (total) =>
        deferred.resolve(new BBModel.PurchaseTotal(total))
      , (err) =>
        deferred.reject(err)

    deferred.promise
