'use strict';

# helpful functions about a company
###**
* @ngdoc object
* @name BB.Models:AffiliateModel
*
* @description
* This is AffiliateModel in BB.Models module that creates Affiliate object.
*
* <pre>
* //Creates class Affiliate that extends BaseModel
* class Affiliate extends BaseModel
* </pre>
*
* @requires {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @requires {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @requires {model} BaseModel Info
* <br>
* {@link BB.Models:BaseModel more}
*
* @returns {object} Newly created Affiliate object with the following set of methods:
*
* - constructor(data)
###
angular.module('BB.Models').factory "AffiliateModel", ($q, BBModel, BaseModel) ->

  class Affiliate extends BaseModel

    constructor: (data) ->
      super(data)
      @test = 1

    getCompanyByRef: (ref) ->
      defer = $q.defer()
      @$get('companies', {reference: ref}).then (company) ->
        if company
          defer.resolve(new BBModel.Company(company))
        else
          defer.reject('No company for ref '+ref)
      , (err) ->
        console .log 'err ', err
        defer.reject(err)
      defer.promise
