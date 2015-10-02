'use strict';

###**
* @ngdoc object
* @name BB.Models:ServiceModel
*
* @description
* This is ServiceModel in BB.Models module that creates Service object.
*
* <pre>
* //Creates class Service that extends BaseModel
* class Service extends BaseModel
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
* @returns {object} Newly created Service object with the following set of methods:
*
* - Service()
* - constructor(data)
* - getPriceByDuration(dur)
* - getCategoryPromise()
* - days_array()
*
###
angular.module('BB.Models').factory "ServiceModel", ($q, BBModel, BaseModel) ->

  class Service extends BaseModel

    constructor: (data) ->
      super
      if @prices && @prices.length > 0
        @price = @prices[0]
      if @durations && @durations.length > 0
        @duration = @durations[0]
      if !@listed_durations
        @listed_durations = @durations
      if @listed_durations && @listed_durations.length > 0
        @listed_duration = @listed_durations[0]

      @min_advance_datetime = moment().add(@min_advance_period, 'seconds')
      @max_advance_datetime = moment().add(@max_advance_period, 'seconds')


    getPriceByDuration: (dur) ->
      for d,i in @durations
        return @prices[i] if d == dur
      # return price


    getCategoryPromise: () =>
      return null if !@$has('category')
      prom = @$get('category')
      prom.then (cat) =>
        @category = new BBModel.Category(cat)
      prom


    days_array: () =>
      arr = []
      for x in [@min_bookings..@max_bookings]
        str = "" + x + " day"
        str += "s" if x > 1
        arr.push({name: str, val: x})
      arr
