'use strict';

###**
* @ngdoc object
* @name BB.Models:EventSequenceModel
*
* @description
* This is EventSequenceModel in BB.Models module that creates EventSequence object.
*
* <pre>
* //Creates class EventSequence that extends BaseModel
* class EventSequence extends BaseModel
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
* @returns {object} Newly created EventSequence object with the following set of methods:
*
* - name()
*
###
angular.module('BB.Models').factory "EventSequenceModel", ($q, BBModel, BaseModel) ->

  class EventSequence extends BaseModel
    name: () ->
      @_data.name
