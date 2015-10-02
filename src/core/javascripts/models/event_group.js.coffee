'use strict';

###**
* @ngdoc object
* @name BB.Models:EventGroupModel
*
* @description
* This is EventGroupModel in BB.Models module that creates EventGroup object.
*
* <pre>
* //Creates class EventGroup that extends BaseModel
* class EventGroup extends BaseModel
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
* @returns {object} Newly created EventGroup object with the following set of methods:
*
* - name()
* - colour()
###
angular.module('BB.Models').factory "EventGroupModel", ($q, BBModel, BaseModel) ->
  class EventGroup extends BaseModel
    name: () ->
      @_data.name

    colour: () ->
      @_data.colour
