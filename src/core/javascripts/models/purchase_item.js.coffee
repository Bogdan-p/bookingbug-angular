
'use strict';

###**
* @ngdoc object
* @name BB.Models:PurchaseItemModel
*
* @description
* This is PurchaseItemModel in BB.Models module that creates PurchaseItem object.
*
* <pre>
* //Creates class PurchaseItem that extends BaseModel
* class PurchaseItem extends BaseModel
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
* @returns {object} Newly created PurchaseItem object with the following set of methods:
*
* - constructor(data)
* - describe()
* - full_describe()
* - hasPrice()
*
###
angular.module('BB.Models').factory "PurchaseItemModel", ($q, BBModel, BaseModel) ->

  class PurchaseItem extends BaseModel

    constructor: (data) ->
      super(data)
      @parts_links = {}
      if data
        if data.$has('service')
          @parts_links.service = data.$href('service')
        if data.$has('resource')
          @parts_links.resource = data.$href('resource')
        if data.$has('person')
          @parts_links.person = data.$href('person')
        if data.$has('company')
          @parts_links.company = data.$href('company')

    describe: ->
      @get('describe')

    full_describe: ->
      @get('full_describe')


    hasPrice: ->
      return (@price && @price > 0)


