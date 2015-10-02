
'use strict';

###**
* @ngdoc object
* @name BB.Models:DayModel
*
* @description
* This is DayModel in BB.Models module that creates Day object.
*
* <pre>
* //Creates class Day that extends BaseModel
* class Day extends BaseModel
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
* @returns {object} Newly created Day object with the following set of methods:
*
* - constructor(data)
* - day
* - off(month)
* - class(month)
*
###
angular.module('BB.Models').factory "DayModel", ($q, BBModel, BaseModel) ->

  class Day extends BaseModel

    constructor: (data) ->
      super
      @string_date = @date
      @date = moment(@date)

    day: ->
      @date.date()

    off: (month) ->
      @date.month() != month

    class: (month) ->
      str = ""
      if @date.month() < month
        str += "off off-prev"
      if @date.month() > month
        str += "off off-next"
      if @spaces == 0
        str += " not-avail"
      str
