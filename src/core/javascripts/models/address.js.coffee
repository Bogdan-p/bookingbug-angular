'use strict';

###**
* @ngdoc object
* @name BB.Models:AddressModel
*
* @description
* This is AddressModel in BB.Models module that creates Address object.
*
* <pre>
* //Creates class Address that extends BaseModel
* class Address extends BaseModel
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
* @returns {object} Newly created Address object with the following set of methods:
*
* - addressSingleLine()
* - hasAddress()
* - addressCsvLine()
* - addressMultiLine()
*
###
angular.module('BB.Models').factory "AddressModel", ($q, BBModel, BaseModel) ->

  class Address extends BaseModel

    addressSingleLine: ->
      str = ""
      str += @address1 if @address1
      str += ", " if @address2 && str.length > 0
      str += @address2 if @address2
      str += ", " if @address3 && str.length > 0
      str += @address3 if @address3
      str += ", " if @address4 && str.length > 0
      str += @address4 if @address4
      str += ", " if @address5 && str.length > 0
      str += @address5 if @address5
      str += ", " if @postcode && str.length > 0
      str += @postcode if @postcode
      str

    hasAddress: ->
      return @address1 || @address2 || @postcode

    addressCsvLine: ->
      str = ""
      str += @address1 if @address1
      str += ", "
      str += @address2 if @address2
      str += ", "
      str += @address3 if @address3
      str += ", "
      str += @address4 if @address4
      str += ", "
      str += @address5 if @address5
      str += ", "
      str += @postcode if @postcode
      str += ", "
      str += @country if @country
      return str

    addressMultiLine: ->
      str = ""
      str += @address1 if @address1
      str += "<br/>" if @address2 && str.length > 0
      str += @address2 if @address2
      str += "<br/>" if @address3 && str.length > 0
      str += @address3 if @address3
      str += "<br/>" if @address4 && str.length > 0
      str += @address4 if @address4
      str += "<br/>" if @address5 && str.length > 0
      str += @address5 if @address5
      str += "<br/>" if @postcode && str.length > 0
      str += @postcode if @postcode
      str
