###**
* @ngdoc service
* @name BB.Services:SpaceService
*
* @description
* Factory SpaceService
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
angular.module('BB.Services').factory "SpaceService", ['$q',  ($q, BBModel) ->
  query: (company) ->
    deferred = $q.defer()
    if !company.$has('spaces')
      deferred.reject("No spaces found")
    else
      company.$get('spaces').then (resource) =>
        resource.$get('spaces').then (items) =>
          spaces = []
          for i in items
            spaces.push(new BBModel.Space(i))
          deferred.resolve(spaces)
      , (err) =>
        deferred.reject(err)

    deferred.promise
]
