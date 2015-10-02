###**
* @ngdoc service
* @name BB.Services:CategoryService
*
* @description
* Factory CategoryService
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
angular.module('BB.Services').factory "CategoryService", ($q, BBModel) ->
  query: (company) ->
    deferred = $q.defer()
    if !company.$has('categories')
      deferred.reject("No categories found")
    else
      company.$get('named_categories').then (resource) =>
        resource.$get('categories').then (items) =>
          categories = []
          for i, _i in items
            cat = new BBModel.Category(i)
            cat.order ||= _i
            categories.push(cat)
          deferred.resolve(categories)
      , (err) =>
        deferred.reject(err)

    deferred.promise
