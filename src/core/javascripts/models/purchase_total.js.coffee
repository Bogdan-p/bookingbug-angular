'use strict';

###**
* @ngdoc object
* @name BB.Models:PurchaseTotalModel
*
* @description
* This is PurchaseTotalModel in BB.Models module that creates PurchaseTotal object.
*
* <pre>
* //Creates class PurchaseTotal that extends BaseModel
* class PurchaseTotal extends BaseModel
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
* @returns {object} Newly created PurchaseTotal object with the following set of methods:
*
* - constructor(data)
* - icalLink()
* - webcalLink()
* - gcalLink()
* - id()
*
###
angular.module('BB.Models').factory "PurchaseTotalModel", ($q, BBModel, BaseModel) ->

  class PurchaseTotal extends BaseModel

    constructor: (data) ->
      super(data)
      @promise = @_data.$get('purchase_items')
      @items = []
      @promise.then (items) =>
        for item in items
          @items.push(new BBModel.PurchaseItem(item))
      if @_data.$has('client')
       cprom = data.$get('client')
       cprom.then (client) =>
         @client = new BBModel.Client(client)


    icalLink: ->
      @_data.$href('ical')


    webcalLink: ->
      @_data.$href('ical')

    gcalLink: ->
      @_data.$href('gcal')

    id: ->
      @get('id')


