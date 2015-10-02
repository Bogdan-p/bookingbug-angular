###**
* @ngdoc service
* @name BB.Services:ServiceService
*
* @description
* Factory ServiceService
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
* - query(company)
*
###
angular.module('BB.Services').factory "ServiceService", ($q, BBModel) ->
  query: (company) ->
    deferred = $q.defer()
    if !company.$has('services')
      deferred.reject("No services found")
    else
      company.$get('services').then (resource) =>
        resource.$get('services').then (items) =>
          services = []
          for i in items
            services.push(new BBModel.Service(i))
          deferred.resolve(services)
      , (err) =>
        deferred.reject(err)

    deferred.promise
