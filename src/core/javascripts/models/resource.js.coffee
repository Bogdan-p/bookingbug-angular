'use strict';

###**
* @ngdoc object
* @name BB.Models:ResourceModel
*
* @description
* This is ResourceModel in BB.Models module that creates Resource object.
*
* <pre>
* //Creates class Resource that extends BaseModel
* class Resource extends BaseModel
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
* @returns {object} Newly created Resource object with the following set of methods:
*
###
angular.module('BB.Models').factory "ResourceModel", ($q, BBModel, BaseModel) ->

  class Resource extends BaseModel


