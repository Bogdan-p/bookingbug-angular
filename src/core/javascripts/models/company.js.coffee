'use strict';

# helpful functions about a company
###**
* @ngdoc object
* @name BB.Models:CompanyModel
*
* @description
* This is CompanyModel in BB.Models module that creates Company object.
*
* <pre>
* //Creates class Company that extends BaseModel
* class Company extends BaseModel
* </pre>
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* * <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {model} BaseModel Info
* <br>
* {@link BB.Models:BaseModel more}
*
* @param {model} halClient Info
*
* @returns {object} Newly created Company object with the following set of methods:
*
* - constructor(data)
* - getCompanyByRef(ref)
* - findChildCompany(id)
* - getSettings()
*
###
angular.module('BB.Models').factory "CompanyModel", ($q, BBModel, BaseModel, halClient) ->

  class Company extends BaseModel

    constructor: (data) ->
      super(data)

      # instantiate each child company as a hal resource
      if @companies
        @companies = _.map @companies, (c) -> new BBModel.Company(halClient.$parse(c))

    getCompanyByRef: (ref) ->
      defer = $q.defer()
      @$get('companies').then (companies) ->
        company = _.find(companies, (c) -> c.reference == ref)
        if company
          defer.resolve(company)
        else
          defer.reject('No company for ref '+ref)
      , (err) ->
        console .log 'err ', err
        defer.reject(err)
      defer.promise

    findChildCompany: (id) ->
      return null if !@companies
      for c in @companies
        if c.id == parseInt(id)
          return c
        if c.ref && c.ref == String(id)
          return c
      # failed to find by id - maybe by name ?
      if typeof id == "string"
        name = id.replace(/[\s\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|'’!<>;:,.~`=+-@£&%"]/g, '').toLowerCase()
        for c in @companies
          cname = c.name.replace(/[\s\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|'’!<>;:,.~`=+-@£&%"]/g, '').toLowerCase()
          if name == cname
            return c
      return null

    getSettings: () ->
      def = $q.defer()
      if @settings
        def.resolve(@settings)
      else
        if @$has('settings')
          @$get('settings').then (set) =>
            @settings = new BBModel.CompanySettings(set)
            def.resolve(@settings)
        else
          def.reject("Company has no settings")
      return def.promise


