'use strict';

###**
* @ngdoc object
* @name BB.Models:SlotModel
*
* @description
* This is SlotModel in BB.Models module that creates Slot object.
*
* <pre>
* //Creates class Slot that extends BaseModel
* class Slot extends BaseModel
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
* @returns {object} Newly created Slot object with the following set of methods:
*
* - constructor(data)
*
###
angular.module('BB.Models').factory "SlotModel", ($q, BBModel, BaseModel) ->

  class Slot extends BaseModel

   constructor: (data) ->
      super(data)
      @datetime = moment(data.datetime)


