###**
* @ngdoc service
* @name BB.Services:PersonService
*
* @description
* Factory PersonService
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
angular.module('BB.Services').factory "PersonService", ($q, BBModel) ->
  query: (company) ->
    deferred = $q.defer()

    if !company.$has('people')
      deferred.reject("No people found")
    else
      company.$get('people').then (resource) =>
        resource.$get('people').then (items) =>
          people = []
          for i in items
            people.push(new BBModel.Person(i))
          deferred.resolve(people)
      , (err) =>
        deferred.reject(err)

    deferred.promise
