'use strict';

###**
* @ngdoc object
* @name BB.Models:BusinessQuestionModel
*
* @description
* This is BusinessQuestionModel in BB.Models module that creates BusinessQuestion object.
*
* <pre>
* //Creates class BusinessQuestion that extends BaseModel
* class BusinessQuestion extends BaseModel
* </pre>
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* * <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} $filter Filters are used for formatting data displayed to the user.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$filter more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {model} BaseModel Info
* <br>
* {@link BB.Models:BaseModel more}
*
* @returns {object} Newly created BusinessQuestion object with the following set of methods:
* - constructor(data)
*
###
angular.module('BB.Models').factory "BusinessQuestionModel", ($q, $filter, BBModel, BaseModel) ->

  class BusinessQuestion extends BaseModel

    constructor: (data) ->
      super(data)
