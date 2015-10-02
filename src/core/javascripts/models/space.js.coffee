'use strict';

###**
* @ngdoc object
* @name BB.Models:SpaceModel
*
* @description
* This is SpaceModel in BB.Models module that creates Space object.
*
* <pre>
* //Creates class Space that extends BaseModel
* class Space extends BaseModel
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
* @returns {object} Newly created Space object with the following set of methods:
*
###
angular.module('BB.Models').factory "SpaceModel", ($q, BBModel, BaseModel) ->

  class Space extends BaseModel


