###**
* @ngdoc service
* @name BB.Services:CompanyService
*
* @description
* Factory CompanyService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} halClient Info
* <br>
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @returns {Promise} This service has the following set of methods:
*
* - query(company_id, options)
* - queryChildren(company)
*
###
angular.module('BB.Services').factory "CompanyService",  ($q, halClient, BBModel) ->
  query: (company_id, options) ->
    options['root'] ||= ""
    url = options['root'] + "/api/v1/company/" + company_id
    deferred = $q.defer()
    halClient.$get(url, options).then (company) =>
      deferred.resolve(company)
    , (err) =>
      deferred.reject(err)

    deferred.promise

  queryChildren: (company) ->
    deferred = $q.defer()
    if !company.$has('companies')
      deferred.reject("No child companies found")
    else
      company.$get('companies').then (resource) =>
        resource.$get('companies').then (items) =>
          companies = []
          for i in items
            companies.push(new BBModel.Company(i))
          deferred.resolve(companies)
      , (err) =>
        deferred.reject(err)

    deferred.promise
