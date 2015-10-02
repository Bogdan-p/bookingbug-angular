###**
* @ngdoc service
* @name BB.Services:DealService
*
* @description
* Factory DealService
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
angular.module('BB.Services').factory "DealService", ($q, BBModel) ->
  query: (company) ->
    deferred = $q.defer()

    if !company.$has('deals')
      deferred.reject("No Deals found")
    else
      company.$get('deals').then (resource) =>
        resource.$get('deals').then (deals) =>
          deals = (new BBModel.Deal(deal) for deal in deals)
          deferred.resolve(deals)
      , (err) =>
        deferred.reject(err)

    deferred.promise
