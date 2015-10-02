'use strict';

###**
* @ngdoc object
* @name BB.Models:BookableItemModel
*
* @description
* This is BookableItemModel in BB.Models module that creates BookableItem object.
*
* <pre>
* //Creates class BookableItem that extends BaseModel
* class BookableItem extends BaseModel
* </pre>
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
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
* @returns {object} Newly created BookableItem object with the following set of methods:
*
* - constructor(data)
*
###
angular.module('BB.Models').factory "BookableItemModel", ($q, BBModel, BaseModel) ->

  class BookableItem extends BaseModel

    item: null

    promise: null


    constructor: (data) ->
      super
      @name = "-Waiting-"
      @ready = $q.defer()
      @promise = @_data.$get('item')
      @promise.then (val) =>
        if val.type == "person"
          @item = new BBModel.Person(val)
          if @item
            for n,m of @item._data
              if @item._data.hasOwnProperty(n) && typeof m != 'function'
                @[n] = m
            @ready.resolve()
          else
            @ready.resolve()
        else if val.type == "resource"
          @item = new BBModel.Resource(val)
          if @item
            for n,m of @item._data
              if @item._data.hasOwnProperty(n) && typeof m != 'function'
                @[n] = m
            @ready.resolve()
          else
            @ready.resolve()
        else if val.type == "service"
          @item = new BBModel.Service(val)
          if @item
            for n,m of @item._data
              if @item._data.hasOwnProperty(n) && typeof m != 'function'
                @[n] = m
            @ready.resolve()
          else
            @ready.resolve()

