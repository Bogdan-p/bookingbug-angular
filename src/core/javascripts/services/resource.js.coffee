###**
* @ngdoc service
* @name BB.Services:ResourceService
*
* @description
* Factory ResourceService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
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
angular.module('BB.Services').factory "ResourceService", ($q, BBModel) ->
  query: (company) ->
    deferred = $q.defer()
    if !company.$has('resources')
      deferred.reject("No resource found")
    else
      company.$get('resources').then (resource) =>
        resource.$get('resources').then (items) =>
          resources = []
          for i in items
            resources.push(new BBModel.Resource(i))
          deferred.resolve(resources)
      , (err) =>
        deferred.reject(err)

    deferred.promise
