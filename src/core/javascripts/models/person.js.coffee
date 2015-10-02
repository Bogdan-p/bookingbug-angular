'use strict';

###**
* @ngdoc object
* @name BB.Models:PersonModel
*
* @description
* This is PersonModel in BB.Models module that creates Person object.
*
* <pre>
* //Creates class Person that extends BaseModel
* class Person extends BaseModel
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
* @returns {object} Newly created Person object with the following set of methods:
*
###
angular.module('BB.Models').factory "PersonModel", ($q, BBModel, BaseModel) ->

  class Person extends BaseModel


